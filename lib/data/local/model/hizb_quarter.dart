class HizbQuarter {
  int pageId;
  int hizbQuarterId;

  HizbQuarter.fromMap(map) {
    pageId = map['page_id'];
    hizbQuarterId = map['hizbQuarter_id'];
  }

  @override
  String toString() {
    return 'HizbQuarter{pageId: $pageId, hizbQuarterId: $hizbQuarterId}';
  }
}
