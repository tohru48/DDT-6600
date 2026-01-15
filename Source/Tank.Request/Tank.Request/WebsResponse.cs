using System;
using System.IO;
using System.Net;
using System.Text;

namespace Tank.Request
{
	public class WebsResponse
	{
		public static string GetPage(string url, string postData, string encodeType, out string err)
		{
			Encoding encoding = Encoding.GetEncoding(encodeType);
			byte[] bytes = encoding.GetBytes(postData);
			try
			{
				HttpWebRequest httpWebRequest = WebRequest.Create(url) as HttpWebRequest;
				CookieContainer cookieContainer = new CookieContainer();
				httpWebRequest.CookieContainer = cookieContainer;
				httpWebRequest.AllowAutoRedirect = true;
				httpWebRequest.Method = "POST";
				httpWebRequest.ContentType = "application/x-www-form-urlencoded";
				httpWebRequest.ContentLength = bytes.Length;
				Stream requestStream = httpWebRequest.GetRequestStream();
				requestStream.Write(bytes, 0, bytes.Length);
				requestStream.Close();
				HttpWebResponse httpWebResponse = httpWebRequest.GetResponse() as HttpWebResponse;
				Stream responseStream = httpWebResponse.GetResponseStream();
				StreamReader streamReader = new StreamReader(responseStream, encoding);
				string text = streamReader.ReadToEnd();
				err = string.Empty;
				return text;
			}
			catch (Exception ex)
			{
				err = ex.Message;
				return string.Empty;
			}
		}
	}
}
