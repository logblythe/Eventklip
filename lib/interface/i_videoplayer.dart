abstract class IVideoPlayer{
  void seekTo(Duration duration);
  void forcePlay(String videoUrl);
  void pause();
}