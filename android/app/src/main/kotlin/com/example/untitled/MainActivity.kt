package com.example.untitled

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import android.util.Log

class MainActivity : FlutterActivity() {
    @Override
    protected fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    @Override
    protected fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        val data: Uri = intent.getData()
        if (data != null) {
            val scheme: String = data.getScheme() // 스킴을 체크하여 구글/카카오 리디렉션 구분

            if ("com.example.untitled".equals(scheme)) {
                // 구글 리디렉션 처리
                val code: String = data.getQueryParameter("code")
                Log.d("GoogleRedirect", "구글 인가 코드: $code")

                // 여기에서 구글 인가 코드로 토큰을 요청할 수 있습니다.
            } else if ("kakaofe4182a212808903410b9c65cac7cf6d".equals(scheme)) {
                // 카카오 리디렉션 처리
                val code: String = data.getQueryParameter("code")
                Log.d("KakaoRedirect", "카카오 인가 코드: $code")
                // 여기에서 카카오 인가 코드로 토큰을 요청할 수 있습니다.
            }
        }
    }
}