using DirectBlur.ViewModel.FileOperations;
using System;
using System.Drawing;
using System.Windows.Input;

namespace DirectBlur.ViewModel.Commands
{
    public class WczytajCommand : ICommand
    {
        public DirectBlurVM VM { get; set; }

        public WczytajCommand(DirectBlurVM vm) => VM = vm;

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

        public bool CanExecute(object parameter) => true;

        public void Execute(object parameter)
        {
            ImportFile();
        }

        public void ImportFile()
        {
            string newImagePath = WczytajPlik.OpenFile();
            if (VM.ImagePath != newImagePath)
            {
                VM.ImagePath = newImagePath;
                try
                {
                    VM.InputImage = new Bitmap(VM.ImagePath);
                }
                catch { }
            }
        }
    }
}
