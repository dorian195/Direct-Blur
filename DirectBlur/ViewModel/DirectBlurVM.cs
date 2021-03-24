using DirectBlur.Model;
using DirectBlur.ViewModel.Commands;
using DirectBlur.ViewModel.FileOperations;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Windows;
using System.Windows.Media.Imaging;
using static DirectBlur.Model.DirectBlurFilter;

namespace DirectBlur.ViewModel
{
    public class DirectBlurVM : INotifyPropertyChanged
    {
        public DirectBlurVM()
        {
            WczytajCommand = new WczytajCommand(this);
            PrzetwarzajCommand = new PrzetwarzajCommand(this);
        }

        private string infoText = "Witaj!";
        public string InfoText
        {
            get => infoText;
            set
            {
                infoText = value;
                OnPropertyChanged("InfoText");
            }
        }

        private bool isResultReady = false;
        public bool IsResultReady
        {
            get => isResultReady;
            set
            {
                isResultReady = value;
                OnPropertyChanged("IsResultReady");
            }
        }

        private int numberOfThreads = 1;
        public int NumberOfThreads
        {
            get => numberOfThreads;
            set
            {
                numberOfThreads = value < 1 ? 1 : (value > 64 ? 64 : value);
                OnPropertyChanged("NumberOfThreads");
            }
        }

        private string imagePath;
        public string ImagePath
        {
            get { return imagePath; }
            set
            {
                imagePath = value;
                OnPropertyChanged("ImagePath");
            }
        }

        public IEnumerable<Algorytmy> AlgorythmChoicesTypeValues
            => Enum.GetValues(typeof(Algorytmy)).Cast<Algorytmy>();
        private Algorytmy selectedAlgorythm;
        public Algorytmy SelectedAlgorythm
        {
            get => selectedAlgorythm;
            set
            {
                selectedAlgorythm = value;
                OnPropertyChanged("SelectedAlgorythm");
            }
        }

        public IEnumerable<Biblioteki> LibraryChoicesTypeValues
            => Enum.GetValues(typeof(Biblioteki)).Cast<Biblioteki>();
        private Biblioteki selectedLibrary;
        public Biblioteki SelectedLibrary
        {
            get => selectedLibrary;
            set
            {
                selectedLibrary = value;
                OnPropertyChanged("SelectedLibrary");
            }
        }

        private BitmapImage inputImageSource;
        public BitmapImage InputImageSource
        {
            get { return inputImageSource; }
            set
            {
                inputImageSource = value;
                OnPropertyChanged("InputImageSource");
            }
        }
        private Bitmap inputImage;
        public Bitmap InputImage
        {
            get { return inputImage; }
            set
            {
                inputImage = value;
                InputImageSource = inputImage == null ? null : WczytajPlik.BitmapToImageSource(inputImage);
                OnPropertyChanged("InputImage");
            }
        }

        private BitmapImage outputImageSource;
        public BitmapImage OutputImageSource
        {
            get { return outputImageSource; }
            set
            {
                outputImageSource = value;
                OnPropertyChanged("OutputImageSource");
            }
        }
        private Bitmap outputImage;
        public Bitmap OutputImage
        {
            get => outputImage;
            set
            {
                outputImage = value;
                OutputImageSource = outputImage == null ? null : WczytajPlik.BitmapToImageSource(outputImage);
                OnPropertyChanged("OutputImage");
            }
        }

        public WczytajCommand WczytajCommand { get; set; }
        public PrzetwarzajCommand PrzetwarzajCommand { get; set; }

        public event PropertyChangedEventHandler PropertyChanged;
        private void OnPropertyChanged(string propertyName)
            => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}
