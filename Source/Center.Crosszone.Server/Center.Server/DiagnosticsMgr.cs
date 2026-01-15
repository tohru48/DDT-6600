using Bussiness;
using SqlDataProvider.Data;
using System;
using System.Diagnostics;
namespace Center.Server
{
	public class DiagnosticsMgr
	{
		public static bool Int(int id, string cmd)
		{
			if (GameProperties.RemoteEnable)
			{
				if (cmd != null && cmd == "Open")
				{
					bool result;
					using (RemoteBussiness remoteBussiness = new RemoteBussiness())
					{
						RemoteServerInfo[] allRemoteServer = remoteBussiness.GetAllRemoteServer();
						RemoteServerInfo[] array = allRemoteServer;
						for (int i = 0; i < array.Length; i++)
						{
							RemoteServerInfo remoteServerInfo = array[i];
							if (remoteServerInfo.ID == id)
							{
								DiagnosticsMgr.ProcessApp(remoteServerInfo.ServerPath);
								result = true;
								return result;
							}
							System.Console.WriteLine("UserID: {0} Request open server: {1}", remoteServerInfo.UserID, remoteServerInfo.ServerName);
						}
						return false;
					}
					return result;
				}
				CenterServer.Instance.SendRemote(id, cmd);
				return true;
			}
			return false;
		}
		public static bool ProcessApp(string pacth)
		{
			new System.Diagnostics.Process
			{
				StartInfo = 
				{
					FileName = string.Format("{0}", pacth)
				}
			}.Start();
			return true;
		}
		public DiagnosticsMgr()
		{
			
			
		}
	}
}
