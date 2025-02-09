class FineDustModel {
  final String dataTime,
      so2Value,
      coValue,
      o3Value,
      no2Value,
      pm10Value,
      khaiValue,
      khaiGrade,
      so2Grade,
      coGrade,
      o3Grade,
      no2Grade,
      pm10Grade;
  final String? pm10Value24,
      pm25Value,
      pm25Value24,
      pm25Grade,
      pm10Grade1h,
      pm25Grade1h,
      so2Flag,
      coFlag,
      o3Flag,
      no2Flag,
      pm10Flag,
      pm25Flag;

  FineDustModel.fromJson(Map<String, dynamic> json)
      : dataTime = json['dataTime'],
        so2Value = json['so2Value'],
        coValue = json['coValue'],
        o3Value = json['o3Value'],
        no2Value = json['no2Value'],
        pm10Value = json['pm10Value'],
        pm10Value24 = json['pm10Value24'],
        pm25Value = json['pm25Value'],
        pm25Value24 = json['pm25Value24'],
        khaiValue = json['khaiValue'],
        khaiGrade = json['khaiGrade'],
        so2Grade = json['so2Grade'],
        coGrade = json['coGrade'],
        o3Grade = json['o3Grade'],
        no2Grade = json['no2Grade'],
        pm10Grade = json['pm10Grade'],
        pm25Grade = json['pm25Grade'],
        pm10Grade1h = json['pm10Grade1h'],
        pm25Grade1h = json['pm25Grade1h'],
        so2Flag = json['so2Flag'],
        coFlag = json['coFlag'],
        o3Flag = json['o3Flag'],
        no2Flag = json['no2Flag'],
        pm10Flag = json['pm10Flag'],
        pm25Flag = json['pm25Flag'];

  FineDustModel({
    required this.dataTime,
    required this.so2Value, //아황산가스 농도
    required this.coValue, //일산화탄소 농도
    required this.o3Value, //오존 농도
    required this.no2Value, //이산화질소 농도
    required this.pm10Value, //미세먼지(PM10) 농도
    this.pm10Value24, //미세먼지(PM10) 24시간예측이동농도
    this.pm25Value, //미세먼지(PM2.5) 농도
    this.pm25Value24, //미세먼지(PM2.5) 24시간예측이동농도
    required this.khaiValue, //통합대기환경수치
    required this.khaiGrade, //통합대기환경지수
    required this.so2Grade, //아황산가스 지수
    required this.coGrade, //일산화탄소 지수
    required this.o3Grade, //오존 지수
    required this.no2Grade, //이산화질소 지수
    required this.pm10Grade, //미세먼지(PM10) 24시간 등급
    this.pm25Grade, //미세먼지(PM2.5) 24시간 등급
    this.pm10Grade1h, //미세먼지(PM10) 1시간 등급
    this.pm25Grade1h, //미세먼지(PM2.5) 1시간 등급
    this.so2Flag, //아황산가스 플래그
    this.coFlag, //일산화탄소 플래그
    this.o3Flag, //오존 플래그
    this.no2Flag, //이산화질소 플래그
    this.pm10Flag, //미세먼지(PM10) 24시간 플래그
    this.pm25Flag, //미세먼지(PM2.5) 24시간 플래그
  });
}
