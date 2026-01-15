using Bussiness;
using Bussiness.Interface;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;

namespace Tank.Request
{
    public class CreateLogin : Page
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetLoginIP => ConfigurationManager.AppSettings["LoginIP"];

        public static bool ValidLoginIP(string ip)
        {
            string getLoginIp = CreateLogin.GetLoginIP;
            if (!string.IsNullOrEmpty(getLoginIp))
            {
                if (!((IEnumerable<string>)getLoginIp.Split('|')).Contains<string>(ip))
                    return false;
            }
            return true;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int result = 1;
            try
            {
                string content = HttpUtility.UrlDecode(this.Request["content"]);
                //string loginToken = HttpUtility.UrlDecode(this.Request["contentFav"]);

                string site = this.Request["site"] == null ? "" : HttpUtility.UrlDecode(this.Request["site"]).ToLower();
                string[] strArray = BaseInterface.CreateInterface().UnEncryptLogin(content, ref result, site);
                if (strArray.Length > 3)
                {
                    string userName = strArray[0].Trim().ToLower();
                    string userpass = strArray[1].Trim().ToLower();

                    //if (!string.IsNullOrEmpty(userName) && !string.IsNullOrEmpty(userpass) && !string.IsNullOrEmpty(loginToken))
                    if (!string.IsNullOrEmpty(userName) && !string.IsNullOrEmpty(userpass))
                    {
                        using (PlayerBussiness bussiness = new PlayerBussiness())
                        {
                            //UserMemInfo userMem = bussiness.GetUserMemSingleByUserToken(loginToken);
                            //if (userMem != null && userMem.UserName == userName)
                            {
                                PlayerManager.Add(BaseInterface.GetNameBySite(userName, site), userpass);
                                result = 0;
                            }
                            //else
                            //{
                            //    result = -1900;
                            //}
                        }
                    }
                    else
                        result = -91010;
                }
                else
                    result = -1900;
            }
            catch (Exception ex)
            {
                CreateLogin.log.Error((object)"CreateLogin:", ex);
                result = -1900;
            }
            this.Response.Write((object)result);
        }
    }
}
