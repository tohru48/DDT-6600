using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Sockets;
using System.Text;

namespace Game.Base
{
    public class CheckConnection
    {
        private static string NetSh(string A)
        {
            try
            {
                ProcessStartInfo processStartInfo = new ProcessStartInfo("netsh", A);
                processStartInfo.RedirectStandardOutput = true;
                processStartInfo.UseShellExecute = false;
                processStartInfo.CreateNoWindow = true;
                Process process = new Process();
                process.StartInfo = processStartInfo;
                process.Start();
                process.WaitForExit();
                return process.StandardOutput.ReadToEnd().Trim().Replace("\r", "").Replace("\n", "");
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
        public static string addbanlist(string A_0, string A_1)
        {
            return NetSh(string.Format("ipsec static add filter filterlist=\"{0}\" srcaddr={1} dstaddr=me protocol=any", (object)A_0, (object)A_1));
        }
        static List<ConnectionList> connection = new List<ConnectionList>();
        static List<string> ban = new List<string>();

        public static void AddList(string _ip, BaseClient client, Socket socket)
        {
            int count = 0;
            connection.Add(new ConnectionList
            {
                ip = _ip,
                conntime = DateTime.Now
            });
            connection.ForEach(delegate (ConnectionList a)
            {
                if (a.ip == _ip)
                {
                    TimeSpan span = DateTime.Now - a.conntime;
                    int sec = Convert.ToInt32(span.TotalSeconds);
                    if (sec <= 3)
                    {
                        count++;
                    }
                }
            });
            if (count >= 3)
            {
                if (BanListCount(_ip) <= 0)
                {
                    socket.Close();
                    ban.Add(_ip);
                    addbanlist("KiwiGuard Block Filter List", _ip);
                    client.Disconnect();
                    Console.WriteLine("{Road Spam : " + DateTime.Now + "} IP: " + _ip);
                }
            }
        }
        public static int BanListCount(string ip)
        { return ban.Count(A => A == ip); }
    }
}
