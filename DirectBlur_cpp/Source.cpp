char* pobierz_adres(char* scan0, int x, int y, int stride, int bitsPerPixel)
{
	return scan0 + y * stride + x * bitsPerPixel / 8;
}

void TransformImageCpp_horiz(char * input, char * output, int wys, int szer, int inputStride, int outputStride, int inputBPP, int outputBPP, int poczatek, int koniec)
{
	for (int i = poczatek + 4; i < koniec - 4; ++i)
		for (int j = 4; j < szer - 4; ++j)
		{
			float czerwony = 0;
			float zielony = 0;
			float niebieski = 0;
			char * adres = pobierz_adres(input, j - 4, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1]; 
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j - 3, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j - 2, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j - 1, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j + 1, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j + 2, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j + 3, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j + 4, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			pobierz_adres(output, j, i, outputStride, outputBPP)[0] = (unsigned char)(czerwony / 9);
			pobierz_adres(output, j, i, outputStride, outputBPP)[1] = (unsigned char)(zielony / 9);
			pobierz_adres(output, j, i, outputStride, outputBPP)[2] = (unsigned char)(niebieski / 9);
		}
}

void TransformImageCpp_vertic(char * input, char * output, int wys, int szer, int inputStride, int outputStride, int inputBPP, int outputBPP, int poczatek, int koniec)
{
	for (int i = poczatek + 4; i < koniec - 4; ++i)
		for (int j = 4; j < szer - 4; ++j)
		{
			float czerwony = 0;
			float zielony = 0;
			float niebieski = 0;
			char * adres = pobierz_adres(input, j, i - 4, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i - 3, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i - 2, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i - 1, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i + 1, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i + 2, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i + 3, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			adres = pobierz_adres(input, j, i + 4, inputStride, inputBPP);
			czerwony += (unsigned char)adres[0];
			zielony += (unsigned char)adres[1];
			niebieski += (unsigned char)adres[2];
			pobierz_adres(output, j, i, outputStride, outputBPP)[0] = (unsigned char)(czerwony / 9);
			pobierz_adres(output, j, i, outputStride, outputBPP)[1] = (unsigned char)(zielony / 9);
			pobierz_adres(output, j, i, outputStride, outputBPP)[2] = (unsigned char)(niebieski / 9);
		}
}

extern "C" __declspec(dllexport) void TransformImageCpp(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int beginLine, int endLine, bool alg)
{
	if (alg)
	{
		TransformImageCpp_horiz(input, output, height, width, inputStride, outputStride, inputBitsPerPixel, outputBitsPerPixel, beginLine, endLine);
	}
	else
	{
		TransformImageCpp_vertic(input, output, height, width, inputStride, outputStride, inputBitsPerPixel, outputBitsPerPixel, beginLine, endLine);
	}
}