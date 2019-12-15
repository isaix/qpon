class Category {
  final String id;
  final String label;
  final String imageUrl;


  Category.fromMap(Map snapshot, String id)
      :
        id = id ?? null,
        label = snapshot['label'] ?? null,
        imageUrl = snapshot['imageUrl'] ?? null;
}