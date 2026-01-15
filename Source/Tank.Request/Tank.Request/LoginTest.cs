using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using Bussiness.Interface;

namespace Tank.Request
{
	public class LoginTest : Page
	{
		protected HtmlForm form1;

		protected void Page_Load(object sender, EventArgs e)
		{
			string text = "onelife";
			string text2 = "733789";
			int num = 1255165271;
			string str = "yk-MotL-qhpAo88-7road-mtl55dantang-login-logddt777";
			string text3 = BaseInterface.md5(text + text2 + num + str);
			string text4 = "content=" + HttpUtility.UrlEncode(text + "|" + text2 + "|" + num + "|" + text3);
			string url = "http://localhost:728/CreateLogin.aspx?content=" + HttpUtility.UrlEncode(text + "|" + text2 + "|" + num + "|" + text3);
			string s = BaseInterface.RequestContent(url);
			base.Response.Write(s);
		}
	}
}
