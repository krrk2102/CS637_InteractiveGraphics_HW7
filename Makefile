GCC_OPTIONS=-Wall -pedantic -I include
GL_OPTIONS=-lGLEW -lGL -lglut
OPTIONS=$(GCC_OPTIONS) $(GL_OPTIONS)


hw7: 
	g++ $@.cpp Common/InitShader.cpp $(OPTIONS) -o $@  

clean:
	rm hw7
