using System.Web;

namespace Tank.Request
{
	public class UpdateVersion : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			context.Response.ContentType = "text/plain";
			context.Response.Write("1");
		}
	}
}
