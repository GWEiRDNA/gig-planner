import 'song_model.dart';

class TransitionModel{
  SongModel A;
  SongModel B;
  int power;
  bool createdManually;

  TransitionModel(
      this.A, this.B, this.power, this.createdManually
  );
}