namespace Game.Base
{
    using System;

    public class eAllowIP
    {
        private static string BB;
        public static string IP6;
        private static string LL;

        static eAllowIP()
        {
            BB = "203.162.121.30";
            LL = "123.30.150.32|123.30.150.33|123.30.150.34|123.30.150.35|42.112.20.161|42.112.20.163|42.112.20.164|123.30.150.17|123.30.150.18";
            IP6 = string.Format("198.50.153.184|{0}|{1}", BB, LL);
        }

        public eAllowIP()
        {
        }

        public static string CheckIp(string str)
        {
            return str;
        }

        public static bool smethod_0(string ip)
        {
            string[] strArray = IP6.Split(new char[] { '|' });
            for (int i = 0; i < strArray.Length; i++)
            {
                if (strArray[i] == CheckIp(ip))
                {
                    return true;
                }
            }
            return true;
        }
    }
}
