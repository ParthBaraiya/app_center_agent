abstract class NetworkImageUrls {
  static const images = [
    'https://picsum.photos/id/12/500/300',
    'https://picsum.photos/id/13/500/300',
    'https://picsum.photos/id/14/500/300',
    'https://picsum.photos/id/42/500/300',
    'https://picsum.photos/id/50/500/300',
    'https://picsum.photos/id/62/500/300',
    'https://picsum.photos/id/69/500/300',
    'https://picsum.photos/id/75/500/300',
    'https://picsum.photos/id/76/500/300',
    'https://picsum.photos/id/106/500/300',
    'https://picsum.photos/id/107/500/300',
    'https://picsum.photos/id/122/500/300',
    'https://picsum.photos/id/136/500/300',
    'https://picsum.photos/id/152/500/300',
    'https://picsum.photos/id/161/500/300',
    'https://picsum.photos/id/167/500/300',
    'https://picsum.photos/id/188/500/300',
    'https://picsum.photos/id/191/500/300',
    'https://picsum.photos/id/197/500/300',
  ];

  static String generateImageUrl(int index) =>
      'https://picsum.photos/id/${index + 100}/500/300';
}
