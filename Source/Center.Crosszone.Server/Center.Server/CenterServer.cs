using Bussiness;
using Bussiness.Managers;
using Bussiness.Protocol;
using Center.Server.Managers;
using Game.Base;
using Game.Base.Events;
using Game.Base.Packets;
using Game.Server.Managers;
using log4net;
using log4net.Config;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Reflection;
using System.Threading;
namespace Center.Server
{
	public class CenterServer : BaseServer
	{
		private static readonly ILog ilog_1;
		private CenterServerConfig centerServerConfig_0;
		private System.Random random_0;
		private string string_0;
		private bool bool_0;
		private bool bool_1;
		private System.Threading.Timer timer_0;
		private System.Threading.Timer timer_1;
		private System.Threading.Timer timer_2;
		private static CenterServer centerServer_0;
		public bool ASSState
		{
			get
			{
				return this.bool_0;
			}
			set
			{
				this.bool_0 = value;
			}
		}
		public bool DailyAwardState
		{
			get
			{
				return this.bool_1;
			}
			set
			{
				this.bool_1 = value;
			}
		}
		public static CenterServer Instance
		{
			get
			{
				return CenterServer.centerServer_0;
			}
		}
		protected override BaseClient GetNewClient()
		{
			return new ServerClient(this);
		}
		public override bool Start()
		{
			bool result;
			try
			{
				System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Normal;
				System.AppDomain.CurrentDomain.UnhandledException += new System.UnhandledExceptionEventHandler(this.method_4);
				GameProperties.Refresh();
                if(!this.InitComponent(this.RecompileScripts(), "Recompile Scripts"))
				{
					result = false;
				}
				else if (!this.InitComponent(this.StartScriptComponents(), "Script components"))
				{
					result = false;
				}
				else if (!this.InitComponent(GameProperties.EDITION == this.string_0, "Check Server Edition:" + this.string_0))
				{
					result = false;
				}
				else if (!this.InitComponent(this.InitSocket(System.Net.IPAddress.Parse(this.centerServerConfig_0.Ip), this.centerServerConfig_0.Port), "InitSocket Port:" + this.centerServerConfig_0.Port))
				{
					result = false;
				}
				else if (!this.InitComponent(CenterService.Start(), "Center Service"))
				{
					result = false;
				}
				else if (!this.InitComponent(ServerMgr.Start(), "Load serverlist"))
				{
					result = false;
				}
				else if (!this.InitComponent(ConsortiaExtraMgr.Init(), "Init ConsortiaLevelMgr"))
				{
					result = false;
				}
				else if (!this.InitComponent(MacroDropMgr.Init(), "Init MacroDropMgr"))
				{
					result = false;
				}
				else if (!this.InitComponent(WorldEventMgr.Init(), "WorldEventMgr Init"))
				{
					result = false;
				}
				else if (!this.InitComponent(WorldActivityMgr.Init(), "WorldActivityMgr Init"))
				{
					result = false;
				}
				else if (!this.InitComponent(LanguageMgr.Setup(""), "LanguageMgr Init"))
				{
					result = false;
				}
				else if (!this.InitComponent(SystemNoticeMgr.Start(), "SystemNoticeMgr Init"))
				{
					result = false;
				}
				else if (!this.InitComponent(EventMgr.Start(), "EventMgr Init"))
				{
					result = false;
				}
				else if (!this.InitComponent(this.InitGlobalTimers(), "Init Global Timers"))
				{
					result = false;
				}
				else
				{
					GameEventMgr.Notify(ScriptEvent.Loaded);
					MacroDropMgr.Start();
					if (!this.InitComponent(base.Start(), "base.Start()"))
					{
						result = false;
					}
					else
					{
						GameEventMgr.Notify(GameServerEvent.Started, this);
						System.GC.Collect(System.GC.MaxGeneration);
						CenterServer.ilog_1.Info("GameCrosszoneServer is now open for connections!");
						GameProperties.Save();
						this.method_3();
						result = true;
					}
				}
			}
			catch (System.Exception ex)
			{
				CenterServer.ilog_1.Error("Failed to start the server", ex);
				result = false;
			}
			return result;
		}
		private void method_3()
		{
			if (GameProperties.RemoteEnable)
			{
				using (RemoteBussiness remoteBussiness = new RemoteBussiness())
				{
					remoteBussiness.ResetStatus();
				}
			}
		}
		private void method_4(object sender, System.UnhandledExceptionEventArgs e)
		{
			CenterServer.ilog_1.Fatal("Unhandled exception!\n" + e.ExceptionObject.ToString());
			if (e.IsTerminating)
			{
				LogManager.Shutdown();
			}
		}
		protected bool InitComponent(bool componentInitState, string text)
		{
			CenterServer.ilog_1.Info(text + ": " + componentInitState);
			if (!componentInitState)
			{
				this.Stop();
			}
			return componentInitState;
		}
		public bool RecompileScripts()
		{
			string text = this.centerServerConfig_0.RootDirectory + System.IO.Path.DirectorySeparatorChar + "scripts";
			if (!System.IO.Directory.Exists(text))
			{
				System.IO.Directory.CreateDirectory(text);
			}
			string[] array = this.centerServerConfig_0.ScriptAssemblies.Split(new char[]
			{
				','
			});
			return ScriptMgr.CompileScripts(false, text, this.centerServerConfig_0.ScriptCompilationTarget, array);
		}
		protected bool StartScriptComponents()
		{
			bool result;
			try
			{
				ScriptMgr.InsertAssembly(typeof(CenterServer).Assembly);
				ScriptMgr.InsertAssembly(typeof(BaseServer).Assembly);
				System.Reflection.Assembly[] scripts = ScriptMgr.Scripts;
				System.Reflection.Assembly[] array = scripts;
				for (int i = 0; i < array.Length; i++)
				{
					System.Reflection.Assembly assembly = array[i];
					GameEventMgr.RegisterGlobalEvents(assembly, typeof(GameServerStartedEventAttribute), GameServerEvent.Started);
					GameEventMgr.RegisterGlobalEvents(assembly, typeof(GameServerStoppedEventAttribute), GameServerEvent.Stopped);
					GameEventMgr.RegisterGlobalEvents(assembly, typeof(ScriptLoadedEventAttribute), ScriptEvent.Loaded);
					GameEventMgr.RegisterGlobalEvents(assembly, typeof(ScriptUnloadedEventAttribute), ScriptEvent.Unloaded);
				}
				CenterServer.ilog_1.Info("Registering global event handlers: true");
				result = true;
			}
			catch (System.Exception ex)
			{
				CenterServer.ilog_1.Error("StartScriptComponents", ex);
				result = false;
			}
			return result;
		}
		public bool InitGlobalTimers()
		{
			int num = this.centerServerConfig_0.SystemNoticeInterval * 60 * 1000;
			if (this.timer_1 == null)
			{
				this.timer_1 = new System.Threading.Timer(new System.Threading.TimerCallback(this.SystemNoticeTimerProc), null, num, num);
			}
			else
			{
				this.timer_1.Change(num, num);
			}
			num = this.centerServerConfig_0.LoginLapseInterval * 60 * 1000;
			if (this.timer_0 == null)
			{
				this.timer_0 = new System.Threading.Timer(new System.Threading.TimerCallback(this.LoginLapseTimerProc), null, num, num);
			}
			else
			{
				this.timer_0.Change(num, num);
			}
			num = 60000;
			if (this.timer_2 == null)
			{
				this.timer_2 = new System.Threading.Timer(new System.Threading.TimerCallback(this.ScanWorldEventProc), null, num, num);
			}
			else
			{
				this.timer_2.Change(num, num);
			}
			return true;
		}
		public void DisposeGlobalTimers()
		{
			if (this.timer_0 != null)
			{
				this.timer_0.Dispose();
			}
			if (this.timer_2 != null)
			{
				this.timer_2.Dispose();
			}
			if (this.timer_1 != null)
			{
				this.timer_1.Dispose();
			}
		}
		protected void SystemNoticeTimerProc(object state)
		{
			try
			{
				int num = System.Environment.TickCount;
				if (CenterServer.ilog_1.IsInfoEnabled)
				{
					CenterServer.ilog_1.Info("System Notice ...");
					CenterServer.ilog_1.Debug("Save ThreadId=" + System.Threading.Thread.CurrentThread.ManagedThreadId);
				}
				System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
				System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
				System.Collections.Generic.List<string> notceList = SystemNoticeMgr.NotceList;
				if (notceList.Count > 0)
				{
					int index = this.random_0.Next(notceList.Count);
					CenterServer.centerServer_0.SendSystemNotice(notceList[index]);
				}
				System.Threading.Thread.CurrentThread.Priority = priority;
				num = System.Environment.TickCount - num;
				if (CenterServer.ilog_1.IsInfoEnabled)
				{
					CenterServer.ilog_1.Info("System Notice complete!");
				}
			}
			catch (System.Exception ex)
			{
				if (CenterServer.ilog_1.IsErrorEnabled)
				{
					CenterServer.ilog_1.Error("SystemNoticeTimerProc", ex);
				}
			}
		}
		protected void LoginLapseTimerProc(object sender)
		{
			try
			{
				Player[] allPlayer = LoginMgr.GetAllPlayer();
				long ticks = System.DateTime.Now.Ticks;
				long num = (long)this.centerServerConfig_0.LoginLapseInterval * 10L * 1000L;
				Player[] array = allPlayer;
				for (int i = 0; i < array.Length; i++)
				{
					Player player = array[i];
					if (player.State == ePlayerState.NotLogin)
					{
						if (player.LastTime + num < ticks)
						{
							LoginMgr.RemovePlayer(player.Id);
						}
					}
					else
					{
						player.LastTime = ticks;
					}
				}
			}
			catch (System.Exception ex)
			{
				if (CenterServer.ilog_1.IsErrorEnabled)
				{
					CenterServer.ilog_1.Error("LoginLapseTimer callback", ex);
				}
			}
		}
		protected void ScanWorldEventProc(object sender)
		{
			try
			{
				int num = System.Environment.TickCount;
				if (CenterServer.ilog_1.IsInfoEnabled)
				{
					CenterServer.ilog_1.Info("Scan  WorldEvent ...");
					CenterServer.ilog_1.Debug("Scan ThreadId=" + System.Threading.Thread.CurrentThread.ManagedThreadId);
				}
				System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
				System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
				this.SendUpdateWorldEvent();
				System.Threading.Thread.CurrentThread.Priority = priority;
				num = System.Environment.TickCount - num;
				if (CenterServer.ilog_1.IsInfoEnabled)
				{
					CenterServer.ilog_1.Info("Scan WorldEvent complete!");
				}
			}
			catch (System.Exception ex)
			{
				if (CenterServer.ilog_1.IsErrorEnabled)
				{
					CenterServer.ilog_1.Error("Scan WorldEvent Proc", ex);
				}
			}
		}
		public override void Stop()
		{
			this.DisposeGlobalTimers();
			CenterService.Stop();
			base.Stop();
		}
		public ServerClient[] GetAllClients()
		{
			ServerClient[] array = null;
			lock (this._clients.SyncRoot)
			{
				array = new ServerClient[this._clients.Count];
				this._clients.Keys.CopyTo(array, 0);
			}
			return array;
		}
		public void method_5(GSPacketIn pkg)
		{
			this.method_6(pkg, null);
		}
		public void method_6(GSPacketIn pkg, ServerClient except)
		{
			ServerClient[] allClients = this.GetAllClients();
			if (allClients != null)
			{
				ServerClient[] array = allClients;
				for (int i = 0; i < array.Length; i++)
				{
					ServerClient serverClient = array[i];
					if (serverClient != except)
					{
						serverClient.SendTCP(pkg);
					}
				}
			}
		}
		public void SendSystemNotice(string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(10);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString(msg);
			this.method_6(gSPacketIn, null);
		}
		public void SendRemote(int id, string cmd)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(243);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteString(cmd);
			this.method_5(gSPacketIn);
		}
		public bool SendAAS(bool state)
		{
			if (StaticFunction.UpdateConfig("Center.Service.exe.config", "AAS", state.ToString()))
			{
				this.ASSState = state;
				GSPacketIn gSPacketIn = new GSPacketIn(7);
				gSPacketIn.WriteBoolean(state);
				this.method_5(gSPacketIn);
				return true;
			}
			return false;
		}
		public bool SendConfigState(int type, bool state)
		{
			string name = string.Empty;
			switch (type)
			{
			case 1:
				name = "AAS";
				break;
			case 2:
				name = "DailyAwardState";
				break;
			default:
				return false;
			}
			if (StaticFunction.UpdateConfig("Center.Service.exe.config", name, state.ToString()))
			{
				switch (type)
				{
				case 1:
					this.ASSState = state;
					break;
				case 2:
					this.DailyAwardState = state;
					break;
				}
				this.SendConfigState();
				return true;
			}
			return false;
		}
		public bool AvailTime(System.DateTime startTime, int min)
		{
			int num = min - (int)(System.DateTime.Now - startTime).TotalMinutes;
			return num > 0;
		}
		public void SendUpdateWorldEvent()
		{
		}
		public void SendConfigState()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(8);
			gSPacketIn.WriteBoolean(this.ASSState);
			gSPacketIn.WriteBoolean(this.DailyAwardState);
			this.method_5(gSPacketIn);
		}
		public int RateUpdate(int serverId)
		{
			ServerClient[] allClients = this.GetAllClients();
			if (allClients != null)
			{
				ServerClient[] array = allClients;
				for (int i = 0; i < array.Length; i++)
				{
					ServerClient serverClient = array[i];
					if (serverClient.Info.ID == serverId)
					{
						GSPacketIn gSPacketIn = new GSPacketIn(177);
						gSPacketIn.WriteInt(serverId);
						serverClient.SendTCP(gSPacketIn);
						return 0;
					}
				}
			}
			return 1;
		}
		public int NoticeServerUpdate(int serverId, int type)
		{
			ServerClient[] allClients = this.GetAllClients();
			if (allClients != null)
			{
				ServerClient[] array = allClients;
				for (int i = 0; i < array.Length; i++)
				{
					ServerClient serverClient = array[i];
					if (serverClient.Info.ID == serverId)
					{
						GSPacketIn gSPacketIn = new GSPacketIn(11);
						gSPacketIn.WriteInt(type);
						serverClient.SendTCP(gSPacketIn);
						return 0;
					}
				}
			}
			return 1;
		}
		public bool SendReload(eReloadType type)
		{
			return this.SendReload(type.ToString());
		}
		public bool SendReload(string str)
		{
			try
			{
				eReloadType eReloadType = (eReloadType)System.Enum.Parse(typeof(eReloadType), str, true);
				eReloadType eReloadType2 = eReloadType;
				if (eReloadType2 == eReloadType.server)
				{
					this.centerServerConfig_0.Refresh();
					this.InitGlobalTimers();
					this.LoadConfig();
					ServerMgr.ReLoadServerList();
					this.SendConfigState();
				}
				GSPacketIn gSPacketIn = new GSPacketIn(11);
				gSPacketIn.WriteInt((int)eReloadType);
				this.method_6(gSPacketIn, null);
				return true;
			}
			catch (System.Exception ex)
			{
				CenterServer.ilog_1.Error("Order is not Exist!", ex);
			}
			return false;
		}
		public void SendShutdown()
		{
			GSPacketIn pkg = new GSPacketIn(15);
			this.method_5(pkg);
		}
		public CenterServer(CenterServerConfig config)
		{
			
			this.random_0 = new System.Random();
			this.string_0 = "5498628";
			
			this.centerServerConfig_0 = config;
			this.LoadConfig();
		}
		public void LoadConfig()
		{
			this.bool_0 = bool.Parse(ConfigurationManager.AppSettings["AAS"]);
			this.bool_1 = bool.Parse(ConfigurationManager.AppSettings["DailyAwardState"]);
		}
		public static void CreateInstance(CenterServerConfig config)
		{
			if (CenterServer.centerServer_0 != null)
			{
				return;
			}
			System.IO.FileInfo fileInfo = new System.IO.FileInfo(config.LogConfigFile);
			if (!fileInfo.Exists)
			{
				ResourceUtil.ExtractResource(fileInfo.Name, fileInfo.FullName, System.Reflection.Assembly.GetAssembly(typeof(CenterServer)));
			}
			XmlConfigurator.ConfigureAndWatch(fileInfo);
			CenterServer.centerServer_0 = new CenterServer(config);
		}
		static CenterServer()
		{
			
			CenterServer.ilog_1 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
