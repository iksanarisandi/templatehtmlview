package com.mycatatan.simple1

import android.annotation.SuppressLint
import android.os.Bundle
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat

class MainActivity : AppCompatActivity() {

    private lateinit var webView: WebView

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable edge-to-edge display
        WindowCompat.setDecorFitsSystemWindows(window, false)

        // Create WebView programmatically
        webView = WebView(this)
        setContentView(webView)

        // Hide system bars for immersive experience
        val insetsController = WindowCompat.getInsetsController(window, webView)
        insetsController.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE

        // Configure WebView settings
        setupWebView()
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setupWebView() {
        with(webView.settings) {
            // Enable JavaScript
            javaScriptEnabled = true

            // Enable DOM Storage
            domStorageEnabled = true

            // Enable database storage
            databaseEnabled = true

            // Set cache mode
            cacheMode = android.webkit.WebSettings.LOAD_DEFAULT

            // Enable zoom
            setSupportZoom(true)
            builtInZoomControls = true
            displayZoomControls = false

            // Improve rendering
            loadWithOverviewMode = true
            useWideViewPort = true

            // Enable content access
            allowContentAccess = true
            allowFileAccess = true
            allowFileAccessFromFileURLs = true
            allowUniversalAccessFromFileURLs = true

            // Set user agent
            userAgentString = "Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"
        }

        // Configure WebView client
        webView.webViewClient = WebViewClient()
        webView.webChromeClient = WebChromeClient()

        // Load local HTML file from assets
        // The index.html should be placed in app/src/main/assets/
        webView.loadUrl("file:///android_asset/index.html")
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    override fun onDestroy() {
        webView.destroy()
        super.onDestroy()
    }
}
