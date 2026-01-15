using Bussiness.Protocol;
using Center.Server.Managers;
using Game.Base;
using Game.Base.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Security.Cryptography;
using System.Text;
namespace Center.Server
{
	public class ServerClient : BaseClient
	{
		private static readonly ILog ilog_1;
		private System.Security.Cryptography.RSACryptoServiceProvider rsacryptoServiceProvider_0;
		private CenterServer centerServer_0;
		public bool NeedSyncMacroDrop;
		public ServerInfo Info
		{
			get;
			set;
		}
		protected override void OnConnect()
		{
			base.OnConnect();
			this.rsacryptoServiceProvider_0 = new System.Security.Cryptography.RSACryptoServiceProvider();
			System.Security.Cryptography.RSAParameters rSAParameters = this.rsacryptoServiceProvider_0.ExportParameters(false);
			this.method_2(rSAParameters.Modulus, rSAParameters.Exponent);
		}
		protected override void OnDisconnect()
		{
			base.OnDisconnect();
			this.rsacryptoServiceProvider_0 = null;
			System.Collections.Generic.List<Player> serverPlayers = LoginMgr.GetServerPlayers(this);
			LoginMgr.RemovePlayer(serverPlayers);
			if (this.Info != null)
			{
				this.Info.State = 1;
				this.Info.Online = 0;
				this.Info = null;
			}
		}
		public override void OnRecvPacket(GSPacketIn pkg)
		{
			short code = pkg.Code;
			if (code <= 37)
			{
				if (code != 1)
				{
					switch (code)
					{
					case 11:
						this.HandleReload(pkg);
						return;
					case 12:
						this.HandlePing(pkg);
						return;
					case 13:
					case 14:
						break;
					case 15:
						this.HandleShutdown(pkg);
						break;
					default:
						if (code != 37)
						{
							return;
						}
						this.HandleChatPersonal(pkg);
						return;
					}
					return;
				}
				this.HandleLogin(pkg);
				return;
			}
			else
			{
				if (code == 73)
				{
					this.HandleCBugle(pkg);
					return;
				}
				if (code == 107)
				{
					this.HandleChatAreaPersonal(pkg);
					return;
				}
				if (code != 178)
				{
					return;
				}
				this.HandleMacroDrop(pkg);
				return;
			}
		}
		public void HandleChatPersonal(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg);
		}
		public void HandleChatAreaPersonal(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg);
		}
		public void HandleLogin(GSPacketIn pkg)
		{
			byte[] rgb = pkg.ReadBytes();
			string[] array = System.Text.Encoding.UTF8.GetString(this.rsacryptoServiceProvider_0.Decrypt(rgb, false)).Split(new char[]
			{
				','
			});
			if (array.Length == 2)
			{
				this.rsacryptoServiceProvider_0 = null;
				int num = int.Parse(array[0]);
				this.Info = ServerMgr.GetServerInfo(num);
				if (this.Info != null)
				{
					if (this.Info.State == 1)
					{
						base.Strict = (false);
						CenterServer.Instance.SendConfigState();
						CenterServer.Instance.SendUpdateWorldEvent();
						this.Info.Online = 0;
						this.Info.State = 2;
						return;
					}
				}
				ServerClient.ilog_1.ErrorFormat("Error Login Packet from {0} want to login with id:{1}, go to dbo.Server_List and check ip {1}", base.TcpEndpoint, num);
				this.Disconnect();
				return;
			}
			ServerClient.ilog_1.ErrorFormat("Error Login Packet from {0}", base.TcpEndpoint);
			this.Disconnect();
		}
		public void HandleUserPublicMsg(GSPacketIn pkg)
		{
			this.centerServer_0.method_6(pkg, this);
		}
		public void HandlePing(GSPacketIn pkg)
		{
			this.Info.Online = pkg.ReadInt();
			this.Info.State = ServerMgr.GetState(this.Info.Online, this.Info.Total);
		}
		public void HandleCBugle(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg);
		}
		public void HandleReload(GSPacketIn pkg)
		{
			eReloadType eReloadType = (eReloadType)pkg.ReadInt();
			int num = pkg.ReadInt();
			bool flag = pkg.ReadBoolean();
			System.Console.WriteLine(string.Concat(new object[]
			{
				num,
				" ",
				eReloadType.ToString(),
				" is reload ",
				flag ? "succeed!" : "fail"
			}));
		}
		public void HandleShutdown(GSPacketIn pkg)
		{
			int num = pkg.ReadInt();
			if (pkg.ReadBoolean())
			{
				System.Console.WriteLine(num + "  begin stoping !");
				return;
			}
			System.Console.WriteLine(num + "  is stoped !");
		}
		public void HandleMacroDrop(GSPacketIn pkg)
		{
			System.Collections.Generic.Dictionary<int, int> dictionary = new System.Collections.Generic.Dictionary<int, int>();
			int num = pkg.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int key = pkg.ReadInt();
				int value = pkg.ReadInt();
				dictionary.Add(key, value);
			}
			MacroDropMgr.DropNotice(dictionary);
			this.NeedSyncMacroDrop = true;
		}
		public void method_2(byte[] m, byte[] e)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(0);
			gSPacketIn.Write(m);
			gSPacketIn.Write(e);
			this.SendTCP(gSPacketIn);
		}
		public void SendASS(bool state)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(7);
			gSPacketIn.WriteBoolean(state);
			this.SendTCP(gSPacketIn);
		}
		public ServerClient(CenterServer svr) : base(new byte[8192], new byte[8192])
		{
			
			
			this.centerServer_0 = svr;
		}
		static ServerClient()
		{
			
			ServerClient.ilog_1 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
