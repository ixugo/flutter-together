import 'package:dio/dio.dart';
import 'package:flutter_together/api/http_error.dart';
import 'package:flutter_together/common/log.dart';

class Http {
  ///超时时间
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 10000;

  static const String GET = 'get';
  static const String POST = 'post';
  static const String DELETE = 'delete';
  static const String PUT = "put";

  static Http _instance = Http._internal();

  factory Http() => _instance;

  Dio dio;

  Http._internal() {
    if (dio == null) {
      // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
      BaseOptions options = new BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        // 响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: RECEIVE_TIMEOUT,
        // Http请求头.
        headers: {},
      );

      dio = new Dio(options);

      // 添加拦截器
      dio.interceptors.add(ErrorInterceptor());
      // dio.interceptors.add(LogInterceptor());

      // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
      // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      //     (client) {
      // client.findProxy = (uri) {
      // return "PROXY $PROXY_IP:$PROXY_PORT";
      // };
      //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
      // client.badCertificateCallback =
      // (X509Certificate cert, String host, int port) => true;
      // };
    }
  }

  ///初始化公共属性
  void init([String baseUrl]) {
    dio.options.baseUrl = baseUrl;
  }

  /// 设置headers
  void setHeaders(Map<String, dynamic> map) {
    dio.options.headers.addAll(map);
  }

  /// 读取本地配置
  // Map<String, dynamic> getAuthorizationHeader() {
  //   var headers;
  //   String accessToken = Global.accessToken;
  //   if (accessToken != null) {
  //     headers = {"Authorization": 'Bearer $accessToken'};
  //   }
  //   return headers;
  // }
  //
  //

  Future request(
    String path, {
    data,
    params,
    Options options,
  }) async {
    // Map<String, dynamic> _authorization = getAuthorizationHeader();
    // if (_authorization != null) {
    // requestOptions = requestOptions.merge(headers: _authorization);
    // }
    //
    logs.d('请求地址：【 ${dio.options.baseUrl}$path ${options.method} 】');

    logs.d('请求数据：【  $data  】');
    data = data ?? {};

    Response response;
    try {
      response = await dio.request(
        path,
        data: data,
        queryParameters: params,
        options: options,
      );
    } catch (e) {}

    logs.d('获取数据：【  ${response.data}  】');
    return response;
  }

  /// restful get 操作
  Future get(
    String path, {
    Map<String, dynamic> params,
  }) async {
    return await request(
      path,
      params: params,
      options: Options(
        method: GET,
      ),
    );
  }

  /// restful post 操作
  Future post(
    String path, {
    Map<String, dynamic> data,
  }) async {
    return await request(
      path,
      data: data,
      options: Options(
        contentType: Headers.jsonContentType,
        method: POST,
      ),
    );
  }

  /// restful put 操作
  Future put(
    String path, {
    Map<String, dynamic> data,
  }) async {
    return await request(
      path,
      data: data,
      options: Options(
        contentType: Headers.jsonContentType,
        method: PUT,
      ),
    );
  }

  /// restful delete 操作
  Future delete(
    String path, {
    Map<String, dynamic> data,
  }) async {
    return await request(
      path,
      data: data,
      options: Options(
        contentType: Headers.jsonContentType,
        method: DELETE,
      ),
    );
  }

  /// restful post form 表单提交操作
  Future postForm(
    String path, {
    Map<String, dynamic> data,
    Options options,
  }) async {
    return await request(
      path,
      data: FormData.fromMap(data),
      options: Options(
        method: POST,
      ),
    );
  }

  Future<Response> getHTML(String url) async {
    return await Dio().get(url);
  }
}
