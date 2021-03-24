using DirectBlur.Model;
using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Windows;
using System.Windows.Input;

namespace DirectBlur.ViewModel.Commands
{
    public class PrzetwarzajCommand : ICommand
    {
        private DirectBlurVM VM { get; set; }

        public PrzetwarzajCommand(DirectBlurVM vm)
        {
            VM = vm;
        }

        public event EventHandler CanExecuteChanged
        {
            add
            {
                CommandManager.RequerySuggested += value;
            }
            remove
            {
                CommandManager.RequerySuggested -= value;
            }
        }

        public bool CanExecute(object parameter)
        { //TODO: recreate this section so it works on loaded image, not the filepath
            Bitmap inputImage = (Bitmap)parameter;
            return inputImage == null ? false : true;
        }

        public void Execute(object parameter)
        {
            RunFunction();
        }

        public void RunFunction()
        {
            double pixelNo = VM.InputImage.Size.Height * VM.InputImage.Size.Width;
            Stopwatch sw = new Stopwatch();
            try
            {
                sw.Start();
                VM.OutputImage = DirectBlurFilter.Przetwarzaj(VM.InputImage, VM.SelectedAlgorythm, VM.SelectedLibrary, VM.NumberOfThreads);
                sw.Stop();
                VM.InfoText = $"Czas: {sw.ElapsedMilliseconds} ms";
            }
            catch (Exception)
            {
                sw.Stop();
                VM.InfoText = $"Error :(";
            }
        }
    }
}
