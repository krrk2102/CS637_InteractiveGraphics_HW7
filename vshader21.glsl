#version 130

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 eyeposition;

uniform vec4 light1_pos;
uniform vec4 light1_diffuse_product, light1_ambient_product, light1_specular_product;
uniform vec4 light2_pos;
uniform vec4 light2_diffuse_product, light2_ambient_product, light2_specular_product;
uniform float shininess;
uniform bool phong;

in vec4 vPosition;
in vec4 vNormal;

out vec4 color;
out vec3 fE1;
out vec3 fE2;
out vec3 fN;
out vec3 fL1;
out vec3 fL2;

void
main()
{
    gl_Position = projection * modelview * vPosition;

    if (!phong) {
        vec4 diffuse1, diffuse2, specular1, specular2;

        vec3 pos = (modelview * vPosition).xyz;
        vec3 L1 = normalize( light1_pos.xyz - pos );
        vec3 L2 = normalize( light2_pos.xyz - pos );
        vec3 E = normalize( -pos );
        vec3 H1 = normalize( L1 + E );
        vec3 H2 = normalize( L2 + E );

        vec3 N1 = normalize( ( modelview*vec4(vNormal.xyz, 0) ).xyz );
        vec3 N2 = normalize( vNormal.xyz );

        float Kd1 = max( dot( L1, N1 ), 0 );
        float Kd2 = max( dot( L2, N2 ), 0 );
        diffuse1 = Kd1 * light1_diffuse_product;
        diffuse2 = Kd2 * light2_diffuse_product;

        float Ks1 = pow( max(dot(N1, H1), 0.0), shininess );
        float Ks2 = pow( max(dot(N2, H2), 0.0), shininess );
        specular1 = Ks1 * light1_specular_product;
        if( dot(L1, N1) < 0.0 ) specular1 = vec4(0.0, 0.0, 0.0, 1.0);
        specular2 = Ks2 * light2_specular_product;
        if( dot(L2, N2) < 0.0 ) specular2 = vec4(0.0, 0.0, 0.0, 1.0);
    
        color = vec4( diffuse1.xyz+diffuse2.xyz+specular1.xyz+specular2.xyz+light1_ambient_product.xyz+light2_ambient_product.xyz, 1 );
    } else {
        fN = vNormal.xyz;
        fE1 = -(modelview*vPosition).xyz;
        fE2 = (eyeposition - vPosition).xyz;

        if ( light1_pos.w != 0.0 ) fL1 = light1_pos.xyz - vPosition.xyz;
        else fL1 = light1_pos.xyz;

        if ( light2_pos.w != 0.0 ) fL2 = light2_pos.xyz - vPosition.xyz;
        else fL2 = light2_pos.xyz;
    }
}
