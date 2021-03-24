using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.ExceptionServices;
using System.Runtime.InteropServices;
using System.Threading.Tasks;

namespace DirectBlur.Model
{
    public unsafe class DirectBlurFilter
    {
        readonly Biblioteki lib;
        readonly Algorytmy alg;
        private Bitmap input;
        private int liczbaWatkow;

        private DirectBlurFilter(Bitmap bitmap, Algorytmy alg, Biblioteki lib, int watki)
        {
            this.liczbaWatkow = watki;
            this.lib = lib;
            this.alg = alg;
            this.input = bitmap;
        }

        internal static Bitmap Przetwarzaj(Bitmap bitmap, Algorytmy alg, Biblioteki lib, int watki)
        {
            if (bitmap == null) return null;
            if (watki < 1 || watki > 64) return null;

            DirectBlurFilter filter = new DirectBlurFilter(bitmap, alg, lib, watki);

            return filter.Start();
        }

        private Bitmap Start()
        {
            Bitmap output = new Bitmap(input);
            BitmapData inputData = input.LockBits(new Rectangle(0, 0, input.Width, input.Height), ImageLockMode.ReadOnly, input.PixelFormat);
            BitmapData outputData = output.LockBits(new Rectangle(0, 0, output.Width, output.Height), ImageLockMode.WriteOnly, output.PixelFormat);
            byte* inputPtr = (byte*)inputData.Scan0.ToPointer();
            byte* outputPtr = (byte*)outputData.Scan0.ToPointer();
            int wysokosc = input.Height;
            int szerokosc = input.Width;
            int inputStride = inputData.Stride;
            int outputStride = outputData.Stride;
            int inputBPP = Image.GetPixelFormatSize(input.PixelFormat);
            int outputBPP = Image.GetPixelFormatSize(output.PixelFormat);
            ParallelOptions opcje = new ParallelOptions
            {
                MaxDegreeOfParallelism = liczbaWatkow
            };
            int regularPartHeight = input.Height / liczbaWatkow;
            if (lib == Biblioteki.asm)
            {
                Parallel.For(0, liczbaWatkow, opcje, picturePart =>
                {
                    int beginLine = regularPartHeight * picturePart;
                    int endLine;
                    if (picturePart == liczbaWatkow - 1) //if last part
                    {
                        endLine = wysokosc;
                        if (picturePart != 0) //if not the only
                            beginLine-=4;
                    }
                    else // not last part
                    {
                        endLine = beginLine + regularPartHeight + 4;
                        if (beginLine > 0) //if the part isnt first nor last
                        {
                            beginLine-=4;
                        }
                    }
                    TransformImageAsm(inputPtr,outputPtr,wysokosc,szerokosc,inputStride,outputStride,inputBPP,outputBPP,beginLine,endLine,alg == Algorytmy.poziomo);
                });
                
            }
            else
            {
                Parallel.For(0, liczbaWatkow, opcje, czescObrazka =>
                {
                    int poczatek = regularPartHeight * czescObrazka;
                    int koniec;
                    if(czescObrazka == liczbaWatkow - 1) //if last part
                    {
                        koniec = wysokosc;
                        if(czescObrazka != 0) //if not the only
                            poczatek-=4;
                    }
                    else // not last part
                    {
                        koniec = poczatek + regularPartHeight + 4;
                        if (poczatek > 0) //if the part isnt first nor last
                        {
                            poczatek-=4;
                        }
                    }
                    TransformImageCpp(inputPtr,outputPtr,wysokosc,szerokosc,inputStride,outputStride,inputBPP,outputBPP,poczatek,koniec,alg == Algorytmy.poziomo);
                });
            }
            input.UnlockBits(inputData);
            output.UnlockBits(outputData);
            return output;
        }


#if (DEBUG)
        [DllImport(@"D:\Uczelnia\JA\DirectBlur\DirectBlur\x64\Debug\DirectBlur_cpp.dll", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
#else
        [DllImport(@"D:\Uczelnia\JA\DirectBlur\DirectBlur\x64\Release\DirectBlur_cpp.dll", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
#endif
        private extern static void TransformImageCpp(byte* input, byte* output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int beginLine, int endLine, bool alg);


#if (DEBUG)
        [DllImport(@"D:\Uczelnia\JA\DirectBlur\DirectBlur\x64\Debug\DirectBlur_asm.dll", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
#else
        [DllImport(@"D:\Uczelnia\JA\DirectBlur\DirectBlur\x64\Release\DirectBlur_asm.dll", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
#endif
        private extern static void TransformImageAsm(byte* input, byte* output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int beginLine, int endLine, bool alg);

        public enum Algorytmy
        {
            poziomo,
            pionowo,
        }

        public enum Biblioteki
        {
            asm,
            cpp,
        }
    }
}
