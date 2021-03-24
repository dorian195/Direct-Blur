extern "C" __declspec(dllexport) void TransformImageAsm(char *, char *, int, int, int, int, int, int, int, int, bool);

extern "C" void TransformHoriz(char * , char *, int, int, int, int, int, int, int *, int, int);
extern "C" void TransformVertic(char *, char *, int, int, int, int, int, int, int *, int, int);

void TransformImageAsm(char * input, char * output, int wys, int szer, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int poczatek, int koniec, bool alg)
{
	if (alg)
	{
		TransformHoriz(input, output, wys, szer, inputStride, outputStride, inputBitsPerPixel, outputBitsPerPixel, nullptr, poczatek, koniec);
	}
	else
	{
		TransformVertic(input, output, wys, szer, inputStride, outputStride, inputBitsPerPixel, outputBitsPerPixel, nullptr, poczatek, koniec);
	}
}