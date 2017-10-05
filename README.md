### AliExpress SDK for Ruby:

#### Authentication:

To use this SDK, you must have an app key and app secret (a.k.a. client id and client secret). These can be obtained [here](https://portals.aliexpress.com/adcenter/apiSetting.htm) if you're using the affiliate program, or [here](http://isvus.aliexpress.com/isv/index.htm) if you're using the ISV API.

In the affiliate program API settings, you'll see the following:

![](https://i.imgur.com/ycMNgMY.png)

The "api key" is your client id, and the "digital signature" is your client secret.

The API uses OAuth for authentication. You need to first go through a manual authorization sequence to get a short-live authorization code. That code can be exchanged for an access token that last 10 hours, and a refresh token that lasts significantly longer.

Using this gem's console, you get obtain an access token as follows:

```
bash $ bin/console
[1] pry(main)> AliExpress.client_id = [YOUR CLIENT ID]
[2] pry(main)> AliExpress.client_secret = [YOUR CLIENT SECRET]
[3] pry(main)> AliExpress::Auth.authorize
Open https://gw.api.alibaba.com/auth/authorize.htm?_aop_signature=REDACTED&client_id=REDACTED&redirect_uri=REDACTED&site=aliexpress&state=REDACTED in your browser, and then enter the code below.
authorization_code> [ENTER YOUR CODE HERE]
{
    "refresh_token_timeout" => "20180402143144000-0700",
                    "aliId" => "[REDACTED]",
           "resource_owner" => "[REDACTED]",
              :access_token => "[REDACTED]",
             :refresh_token => "[REDACTED]",
                :expires_at => 1507194954
}
```

Once your tokens are obtained, you can instruct this SDK to use them:

```
AliExpress.access_token = [YOUR ACCESS TOKEN]
AliExpress.refresh_token = [YOUR REFRESH TOKEN]
```

If your access token expires, you can get a new one with the following:

```
AliExpress::Auth.refresh
```
