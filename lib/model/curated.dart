class Curated {
  int page = 0;
  int perPage = 0;
  List<Photos> photos = [];
  int totalResults = 0;
  String nextPage = "";

  Curated();

  Curated.fromJson(Map<String, dynamic> json) {
    page = json['page'] ?? 0;
    perPage = json['per_page'] ?? 0;
    if (json['photos'] != null) {
      photos = [];
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    totalResults = json['total_results'] ?? 0;
    nextPage = json['next_page'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['photos'] = this.photos.map((v) => v.toJson()).toList();
    data['total_results'] = this.totalResults;
    data['next_page'] = this.nextPage;
    return data;
  }
}

class Photos {
  int id = 0;
  int width = 0;
  int height = 0;
  String url = "";
  String photographer = "";
  String photographerUrl = "";
  int photographerId = 0;
  String avgColor = "";
  Src src = Src();
  bool liked = false;

  Photos(
      this.id,
      this.width,
      this.height,
      this.url,
      this.photographer,
      this.photographerUrl,
      this.photographerId,
      this.avgColor,
      this.src,
      this.liked);

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    photographer = json['photographer'];
    photographerUrl = json['photographer_url'];
    photographerId = json['photographer_id'];
    avgColor = json['avg_color'];
    src = (json['src'] != null ? new Src.fromJson(json['src']) : null)!;
    liked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['width'] = this.width;
    data['height'] = this.height;
    data['url'] = this.url;
    data['photographer'] = this.photographer;
    data['photographer_url'] = this.photographerUrl;
    data['photographer_id'] = this.photographerId;
    data['avg_color'] = this.avgColor;
    data['src'] = this.src.toJson();
    data['liked'] = this.liked;
    return data;
  }
}

class Src {
  String original = "";
  String large2x = "";
  String large = "";
  String medium = "";
  String small = "";
  String portrait = "";
  String landscape = "";
  String tiny = "";

  Src(
      {this.original = "",
      this.large2x = "",
      this.large = "",
      this.medium = "",
      this.small = "",
      this.portrait = "",
      this.landscape = "",
      this.tiny = ""});

  Src.fromJson(Map<String, dynamic> json) {
    original = json['original'];
    large2x = json['large2x'];
    large = json['large'];
    medium = json['medium'];
    small = json['small'];
    portrait = json['portrait'];
    landscape = json['landscape'];
    tiny = json['tiny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original'] = this.original;
    data['large2x'] = this.large2x;
    data['large'] = this.large;
    data['medium'] = this.medium;
    data['small'] = this.small;
    data['portrait'] = this.portrait;
    data['landscape'] = this.landscape;
    data['tiny'] = this.tiny;
    return data;
  }
}
