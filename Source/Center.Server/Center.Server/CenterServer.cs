using Bussiness;
using Bussiness.Managers;
using Bussiness.Protocol;
using Center.Server.Managers;
using Center.Server.Statics;
using Game.Base;
using Game.Base.Events;
using Game.Base.Packets;
using Game.Server.Managers;
using log4net;
using log4net.Config;
using SqlDataProvider.Data;
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
        private string string_0;
        private System.Random random_0;
        private bool bool_0;
        private bool bool_1;
        private System.Threading.Timer timer_0;
        private System.Threading.Timer kndYuBjeU;
        private System.Threading.Timer timer_1;
        private System.Threading.Timer timer_2;
        private System.Threading.Timer timer_3;
        private System.Threading.Timer timer_4;
        private System.Threading.Timer timer_5;
        private System.Threading.Timer timer_6;
        private System.Threading.Timer timer_7;
        private readonly int int_1;
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
        public bool clearDB()
        {
            using (PlayerBussiness playerBussiness = new PlayerBussiness())
            {
                playerBussiness.ClearDatabase();
            }
            return true;
        }
        public override bool Start()
        {
            bool result;
            try
            {
                System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Normal;
                System.AppDomain.CurrentDomain.UnhandledException += new System.UnhandledExceptionEventHandler(this.method_3);
                GameProperties.Refresh();
                if (!this.InitComponent(this.RecompileScripts(), "Recompile Scripts"))
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
                else if (!this.InitComponent(LanguageMgr.Setup(""), "LanguageMgr Init"))
                {
                    result = false;
                }
                else if (!this.InitComponent(WorldMgr.Start(), "WorldMgr Init"))
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
                        CenterServer.ilog_1.Info("GameServer is now open for connections!");
                        this.SaveRemote(this.centerServerConfig_0.Port, 3, "Running...");
                        GameProperties.Save();
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
        public void SaveRemote(int port, int status, string test)
        {
            if (GameProperties.RemoteEnable)
            {
                using (RemoteBussiness remoteBussiness = new RemoteBussiness())
                {
                    remoteBussiness.UpdateServer(port, status, test);
                }
            }
        }
        private void method_3(object sender, System.UnhandledExceptionEventArgs e)
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
            int num = this.centerServerConfig_0.SaveIntervalInterval * 60 * 1000;
            if (this.kndYuBjeU == null)
            {
                this.kndYuBjeU = new System.Threading.Timer(new System.Threading.TimerCallback(this.SaveTimerProc), null, num, num);
            }
            else
            {
                this.kndYuBjeU.Change(num, num);
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
            num = this.centerServerConfig_0.SaveRecordInterval * 60 * 1000;
            if (this.timer_1 == null)
            {
                this.timer_1 = new System.Threading.Timer(new System.Threading.TimerCallback(this.SaveRecordProc), null, num, num);
            }
            else
            {
                this.timer_1.Change(num, num);
            }
            num = this.centerServerConfig_0.ScanAuctionInterval * 60 * 1000;
            if (this.timer_2 == null)
            {
                this.timer_2 = new System.Threading.Timer(new System.Threading.TimerCallback(this.ScanAuctionProc), null, num, num);
            }
            else
            {
                this.timer_2.Change(num, num);
            }
            num = this.centerServerConfig_0.ScanMailInterval * 60 * 1000;
            if (this.timer_3 == null)
            {
                this.timer_3 = new System.Threading.Timer(new System.Threading.TimerCallback(this.ScanMailProc), null, num, num);
            }
            else
            {
                this.timer_3.Change(num, num);
            }
            num = this.centerServerConfig_0.ScanConsortiaInterval * 60 * 1000;
            if (this.timer_4 == null)
            {
                this.timer_4 = new System.Threading.Timer(new System.Threading.TimerCallback(this.ScanConsortiaProc), null, num, num);
            }
            else
            {
                this.timer_4.Change(num, num);
            }
            num = 60000;
            if (this.timer_5 == null)
            {
                this.timer_5 = new System.Threading.Timer(new System.Threading.TimerCallback(this.ScanWorldEventProc), null, num, num);
            }
            else
            {
                this.timer_5.Change(num, num);
            }
            if (this.timer_6 == null)
            {
                this.timer_6 = new System.Threading.Timer(new System.Threading.TimerCallback(this.ScanConsortiabossProc), null, num, num);
            }
            else
            {
                this.timer_6.Change(num, num);
            }
            if (this.timer_7 == null)
            {
                this.timer_7 = new System.Threading.Timer(new System.Threading.TimerCallback(this.ScanRemoteProc), null, num, num);
            }
            else
            {
                this.timer_7.Change(num, num);
            }
            return true;
        }
        public void DisposeGlobalTimers()
        {
            if (this.timer_7 != null)
            {
                this.timer_7.Dispose();
            }
            if (this.kndYuBjeU != null)
            {
                this.kndYuBjeU.Dispose();
            }
            if (this.timer_0 != null)
            {
                this.timer_0.Dispose();
            }
            if (this.timer_1 != null)
            {
                this.timer_1.Dispose();
            }
            if (this.timer_2 != null)
            {
                this.timer_2.Dispose();
            }
            if (this.timer_3 != null)
            {
                this.timer_3.Dispose();
            }
            if (this.timer_4 != null)
            {
                this.timer_4.Dispose();
            }
            if (this.timer_5 != null)
            {
                this.timer_5.Dispose();
            }
            if (this.timer_6 != null)
            {
                this.timer_6.Dispose();
            }
        }
        protected void ScanRemoteProc(object sender)
        {
            try
            {
                int num = System.Environment.TickCount;
                System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
                System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
                if (GameProperties.RemoteEnable)
                {
                    using (RemoteBussiness remoteBussiness = new RemoteBussiness())
                    {
                        RemoteServerInfo[] allRemoteServer = remoteBussiness.GetAllRemoteServer();
                        int num2 = 0;
                        int num3 = 0;
                        RemoteServerInfo[] array = allRemoteServer;
                        for (int i = 0; i < array.Length; i++)
                        {
                            RemoteServerInfo remoteServerInfo = array[i];
                            if (remoteServerInfo.ProcessID == 3 && remoteServerInfo.ZoneID == this.centerServerConfig_0.ZoneId && remoteServerInfo.UserID == this.centerServerConfig_0.ServerID)
                            {
                                num2++;
                                if (remoteServerInfo.ProcessStatus == 0)
                                {
                                    num3++;
                                }
                            }
                        }
                        if (num2 + num3 > 0 && num2 == num3)
                        {
                            this.Stop();
                        }
                    }
                }
                System.Threading.Thread.CurrentThread.Priority = priority;
                num = System.Environment.TickCount - num;
            }
            catch
            {
            }
        }
        protected void SaveTimerProc(object state)
        {
            try
            {
                int num = System.Environment.TickCount;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Saving database...");
                    CenterServer.ilog_1.Debug("Save ThreadId=" + System.Threading.Thread.CurrentThread.ManagedThreadId);
                }
                System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
                System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
                ServerMgr.SaveToDatabase();
                System.Threading.Thread.CurrentThread.Priority = priority;
                num = System.Environment.TickCount - num;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Saving database complete!");
                    CenterServer.ilog_1.Info("Saved all databases " + num + "ms");
                }
            }
            catch (System.Exception ex)
            {
                if (CenterServer.ilog_1.IsErrorEnabled)
                {
                    CenterServer.ilog_1.Error("SaveTimerProc", ex);
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
        protected void SaveRecordProc(object sender)
        {
            try
            {
                int num = System.Environment.TickCount;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Saving Record...");
                    CenterServer.ilog_1.Debug("Save ThreadId=" + System.Threading.Thread.CurrentThread.ManagedThreadId);
                }
                System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
                System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
                LogMgr.Save();
                System.Threading.Thread.CurrentThread.Priority = priority;
                num = System.Environment.TickCount - num;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Saving Record complete!");
                }
                if (num > 120000)
                {
                    CenterServer.ilog_1.WarnFormat("Saved all Record  in {0} ms!", num);
                }
            }
            catch (System.Exception ex)
            {
                if (CenterServer.ilog_1.IsErrorEnabled)
                {
                    CenterServer.ilog_1.Error("SaveRecordProc", ex);
                }
            }
        }
        protected void ScanAuctionProc(object sender)
        {
            try
            {
                int num = System.Environment.TickCount;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Saving Record...");
                    CenterServer.ilog_1.Debug("Save ThreadId=" + System.Threading.Thread.CurrentThread.ManagedThreadId);
                }
                System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
                System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
                string text = "";
                using (PlayerBussiness playerBussiness = new PlayerBussiness())
                {
                    playerBussiness.ScanAuction(ref text);
                }
                string[] array = text.Split(new char[]
				{
					','
				});
                string[] array2 = array;
                for (int i = 0; i < array2.Length; i++)
                {
                    string text2 = array2[i];
                    if (!string.IsNullOrEmpty(text2))
                    {
                        GSPacketIn gSPacketIn = new GSPacketIn(117);
                        gSPacketIn.WriteInt(int.Parse(text2));
                        gSPacketIn.WriteInt(1);
                        this.method_4(gSPacketIn);
                    }
                }
                System.Threading.Thread.CurrentThread.Priority = priority;
                num = System.Environment.TickCount - num;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Scan Auction complete!");
                }
                if (num > 120000)
                {
                    CenterServer.ilog_1.WarnFormat("Scan all Auction  in {0} ms", num);
                }
            }
            catch (System.Exception ex)
            {
                if (CenterServer.ilog_1.IsErrorEnabled)
                {
                    CenterServer.ilog_1.Error("ScanAuctionProc", ex);
                }
            }
        }
        protected void ScanMailProc(object sender)
        {
            try
            {
                int num = System.Environment.TickCount;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Saving Record...");
                    CenterServer.ilog_1.Debug("Save ThreadId=" + System.Threading.Thread.CurrentThread.ManagedThreadId);
                }
                System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
                System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
                string text = "";
                using (PlayerBussiness playerBussiness = new PlayerBussiness())
                {
                    playerBussiness.ScanMail(ref text);
                }
                string[] array = text.Split(new char[]
				{
					','
				});
                string[] array2 = array;
                for (int i = 0; i < array2.Length; i++)
                {
                    string text2 = array2[i];
                    if (!string.IsNullOrEmpty(text2))
                    {
                        GSPacketIn gSPacketIn = new GSPacketIn(117);
                        gSPacketIn.WriteInt(int.Parse(text2));
                        gSPacketIn.WriteInt(1);
                        this.method_4(gSPacketIn);
                    }
                }
                System.Threading.Thread.CurrentThread.Priority = priority;
                num = System.Environment.TickCount - num;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Scan Mail complete!");
                }
                if (num > 120000)
                {
                    CenterServer.ilog_1.WarnFormat("Scan all Mail in {0} ms", num);
                }
            }
            catch (System.Exception ex)
            {
                if (CenterServer.ilog_1.IsErrorEnabled)
                {
                    CenterServer.ilog_1.Error("ScanMailProc", ex);
                }
            }
        }
        protected void ScanConsortiabossProc(object sender)
        {
            try
            {
                int num = System.Environment.TickCount;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Scan Consortiaboss...");
                    CenterServer.ilog_1.Debug("Scan ThreadId=" + System.Threading.Thread.CurrentThread.ManagedThreadId);
                }
                System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
                System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
                ConsortiaBossMgr.UpdateTime();
                ConsortiaBossMgr.TimeCheckingAward++;
                if (ConsortiaBossMgr.TimeCheckingAward > 5)
                {
                    System.Collections.Generic.List<int> allConsortiaGetAward = ConsortiaBossMgr.GetAllConsortiaGetAward();
                    GSPacketIn gSPacketIn = new GSPacketIn(185);
                    gSPacketIn.WriteInt(allConsortiaGetAward.Count);
                    foreach (int current in allConsortiaGetAward)
                    {
                        gSPacketIn.WriteInt(current);
                    }
                    this.method_4(gSPacketIn);
                    ConsortiaBossMgr.TimeCheckingAward = 0;
                    CenterServer.ilog_1.Info("Scan Consortiaboss award complete!");
                }
                System.Threading.Thread.CurrentThread.Priority = priority;
                num = System.Environment.TickCount - num;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Scan Consortiaboss complete!");
                }
            }
            catch (System.Exception ex)
            {
                if (CenterServer.ilog_1.IsErrorEnabled)
                {
                    CenterServer.ilog_1.Error("ScanConsortiabossProc", ex);
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
        protected void ScanConsortiaProc(object sender)
        {
            try
            {
                int num = System.Environment.TickCount;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Saving Record...");
                    CenterServer.ilog_1.Debug("Save ThreadId=" + System.Threading.Thread.CurrentThread.ManagedThreadId);
                }
                System.Threading.ThreadPriority priority = System.Threading.Thread.CurrentThread.Priority;
                System.Threading.Thread.CurrentThread.Priority = System.Threading.ThreadPriority.Lowest;
                string text = "";
                using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
                {
                    consortiaBussiness.ScanConsortia(ref text);
                }
                string[] array = text.Split(new char[]
				{
					','
				});
                string[] array2 = array;
                for (int i = 0; i < array2.Length; i++)
                {
                    string text2 = array2[i];
                    if (!string.IsNullOrEmpty(text2))
                    {
                        GSPacketIn gSPacketIn = new GSPacketIn(128);
                        gSPacketIn.WriteByte(2);
                        gSPacketIn.WriteInt(int.Parse(text2));
                        this.method_4(gSPacketIn);
                    }
                }
                System.Threading.Thread.CurrentThread.Priority = priority;
                num = System.Environment.TickCount - num;
                if (CenterServer.ilog_1.IsInfoEnabled)
                {
                    CenterServer.ilog_1.Info("Scan Consortia complete!");
                }
                if (num > 120000)
                {
                    CenterServer.ilog_1.WarnFormat("Scan all Consortia in {0} ms", num);
                }
            }
            catch (System.Exception ex)
            {
                if (CenterServer.ilog_1.IsErrorEnabled)
                {
                    CenterServer.ilog_1.Error("ScanConsortiaProc", ex);
                }
            }
        }
        public override void Stop()
        {
            this.DisposeGlobalTimers();
            this.SaveTimerProc(null);
            this.SaveRecordProc(null);
            this.SaveRemote(this.centerServerConfig_0.Port, 0, "Stopped");
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
        public void method_4(GSPacketIn pkg)
        {
            this.method_5(pkg, null);
        }
        public void method_5(GSPacketIn pkg, ServerClient except)
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
        public void SendConsortiaDelete(int consortiaID)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(5);
            gSPacketIn.WriteInt(consortiaID);
            this.method_4(gSPacketIn);
        }
        public void SendSystemNotice(string msg)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(10);
            gSPacketIn.WriteInt(0);
            gSPacketIn.WriteString(msg);
            this.method_5(gSPacketIn, null);
        }
        public bool SendAAS(bool state)
        {
            if (StaticFunction.UpdateConfig("Center.Service.exe.config", "AAS", state.ToString()))
            {
                this.ASSState = state;
                GSPacketIn gSPacketIn = new GSPacketIn(7);
                gSPacketIn.WriteBoolean(state);
                this.method_4(gSPacketIn);
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
        public void SendLeagueOpenClose(bool value)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(87);
            gSPacketIn.WriteBoolean(value);
            this.method_4(gSPacketIn);
        }
        public void SendBattleGoundOpenClose(bool value)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(88);
            gSPacketIn.WriteBoolean(value);
            this.method_4(gSPacketIn);
        }
        public void SendFightFootballTime(bool value)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(89);
            gSPacketIn.WriteBoolean(value);
            this.method_4(gSPacketIn);
        }
        public void SendUpdateWorldEvent()
        {
            int hour = System.DateTime.Now.Hour;
            if ((hour >= 9 && hour < 10) || (hour >= 18 && hour < 19))
            {
                if (!WorldMgr.IsBattleGoundOpen)
                {
                    this.SendBattleGoundOpenClose(true);
                    WorldMgr.IsBattleGoundOpen = true;
                    WorldMgr.BattleGoundOpenTime = System.DateTime.Now;
                    this.SendSystemNotice("Arena foi aberto. Rapidamente Vamos participar?");
                }
            }
            else if (WorldMgr.IsBattleGoundOpen)
            {
                this.SendBattleGoundOpenClose(false);
                WorldMgr.IsBattleGoundOpen = false;
                this.SendSystemNotice("Arena Terminou.");
            }
            if (hour >= 20 && hour < 22)
            {
                if (!WorldMgr.IsLeagueOpen)
                {
                    this.SendLeagueOpenClose(true);
                    WorldMgr.IsLeagueOpen = true;
                    WorldMgr.LeagueOpenTime = System.DateTime.Now;
                    //this.SendSystemNotice("Chiến thần đã mở. Nhanh chóng tham gia nào các Gunner.");
                }
            }
            else if (WorldMgr.IsLeagueOpen)
            {
                this.SendLeagueOpenClose(false);
                WorldMgr.IsLeagueOpen = false;
                //this.SendSystemNotice("Chiến thần hôm nay kết thúc.");
            }
            string[] array = GameProperties.FightFootballTime.Split(new char[]
			{
				'|'
			});
            if (WorldMgr.IsFightFootballTime)
            {
                int min = int.Parse(array[1]);
                if (!this.AvailTime(WorldMgr.FightFootballTime, min))
                {
                    this.SendFightFootballTime(false);
                    WorldMgr.IsFightFootballTime = false;
                    this.SendSystemNotice("Decida hoje acabar com a guerra.");
                }
            }
            else if (hour.ToString() == array[0] && !WorldMgr.IsFightFootballTime)
            {
                this.SendFightFootballTime(true);
                WorldMgr.IsFightFootballTime = true;
                WorldMgr.FightFootballTime = System.DateTime.Now;
                this.SendSystemNotice("Evento do Futebol aberto. Rapidamente vamos participar?");
            }
            if (!WorldMgr.worldOpen)
            {
                if (hour == 13)
                {
                    this.SendPrivateInfo();
                    WorldMgr.SetupWorldBoss(0);
                    this.SendSystemNotice(string.Format("Chefe do mundo {0} abriu, junte-se agora!", WorldMgr.name[0]));
                }
                else if (hour == 19)
                {
                    this.SendPrivateInfo();
                    WorldMgr.SetupWorldBoss(3);
                    this.SendSystemNotice(string.Format("Chefe do mundo {0} abriu, junte-se agora", WorldMgr.name[3]));
                }
                else
                {
                    this.SendRoomClose(1);
                    this.SendRoomClose(0);
                }
            }
            if (WorldMgr.worldOpen)
            {
                int minute = System.DateTime.Now.Minute;
                if (hour == 14 || hour == 20)
                {
                    if (!WorldMgr.fightOver)
                    {
                        WorldMgr.WorldBossFightOver();
                        this.SendWorldBossFightOver();
                    }
                    if (minute < 5)
                    {
                        int currentPVE_ID = WorldMgr.currentPVE_ID;
                        this.SendSystemNotice(string.Format("Chefe do mundo {0} foi encerrado. Quarto vai fechar em {1} minutos.", WorldMgr.name[currentPVE_ID], 5 - minute));
                    }
                    else if (!WorldMgr.roomClose)
                    {
                        WorldMgr.WorldBossRoomClose();
                        WorldMgr.WorldBossClose();
                        this.SendRoomClose(0);
                        this.SendUpdateRank(true);
                    }
                }
                this.SendPrivateInfo();
                WorldMgr.UpdateFightTime();
            }
            int hour2 = System.DateTime.Now.Hour;
            if (hour2 > this.int_1 && WorldMgr.CanSendLightriddleAward)
            {
                WorldMgr.SendLightriddleTopEightAward();
            }
            if (hour2 > this.int_1 && WorldMgr.CanSendLuckyStarAward)
            {
                WorldMgr.SendLuckyStarTopTenAward();
            }
            if (hour2 > 1 && hour2 < this.int_1)
            {
                if (!WorldMgr.CanSendLightriddleAward)
                {
                    WorldMgr.CanSendLightriddleAward = true;
                    WorldMgr.ResetLightriddleRank();
                }
                if (!WorldMgr.CanSendLuckyStarAward)
                {
                    WorldMgr.CanSendLuckyStarAward = true;
                    WorldMgr.ResetLuckStar();
                }
            }
            WorldMgr.SaveLuckyStarRewardRecord();
        }
        public void SendPrivateInfo()
        {
            int currentPVE_ID = WorldMgr.currentPVE_ID;
            GSPacketIn gSPacketIn = new GSPacketIn(80);
            gSPacketIn.WriteLong(WorldMgr.MAX_BLOOD);
            gSPacketIn.WriteLong(WorldMgr.current_blood);
            gSPacketIn.WriteString(WorldMgr.name[currentPVE_ID]);
            gSPacketIn.WriteString(WorldMgr.bossResourceId[currentPVE_ID]);
            gSPacketIn.WriteInt(WorldMgr.Pve_Id[currentPVE_ID]);
            gSPacketIn.WriteBoolean(WorldMgr.fightOver);
            gSPacketIn.WriteBoolean(WorldMgr.roomClose);
            gSPacketIn.WriteDateTime(WorldMgr.begin_time);
            gSPacketIn.WriteDateTime(WorldMgr.end_time);
            gSPacketIn.WriteInt(WorldMgr.fight_time);
            gSPacketIn.WriteBoolean(WorldMgr.worldOpen);
            this.method_4(gSPacketIn);
        }
        public void SendUpdateRank(bool type)
        {
            System.Collections.Generic.List<RankingPersonInfo> list = WorldMgr.SelectTopTen();
            if (list.Count == 0)
            {
                return;
            }
            GSPacketIn gSPacketIn = new GSPacketIn(81);
            gSPacketIn.WriteBoolean(type);
            gSPacketIn.WriteInt(list.Count);
            foreach (RankingPersonInfo current in list)
            {
                gSPacketIn.WriteInt(current.ID);
                gSPacketIn.WriteString(current.Name);
                gSPacketIn.WriteInt(current.Damage);
            }
            this.method_4(gSPacketIn);
        }
        public void SendPrivateInfo(string name)
        {
            if (!WorldMgr.CheckName(name))
            {
                return;
            }
            GSPacketIn gSPacketIn = new GSPacketIn(85);
            RankingPersonInfo singleRank = WorldMgr.GetSingleRank(name);
            gSPacketIn.WriteString(name);
            gSPacketIn.WriteInt(singleRank.Damage);
            gSPacketIn.WriteInt(singleRank.Honor);
            this.method_4(gSPacketIn);
        }
        public void SendWorldBossFightOver()
        {
            GSPacketIn pkg = new GSPacketIn(82);
            this.method_4(pkg);
        }
        public void SendUpdateWorldBlood()
        {
            GSPacketIn gSPacketIn = new GSPacketIn(79);
            gSPacketIn.WriteLong(WorldMgr.MAX_BLOOD);
            gSPacketIn.WriteLong(WorldMgr.current_blood);
            this.method_4(gSPacketIn);
        }
        public void SendRoomClose(byte type)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(83);
            gSPacketIn.WriteByte(type);
            this.method_4(gSPacketIn);
        }
        public void SendConfigState()
        {
            GSPacketIn gSPacketIn = new GSPacketIn(8);
            gSPacketIn.WriteBoolean(this.ASSState);
            gSPacketIn.WriteBoolean(this.DailyAwardState);
            this.method_4(gSPacketIn);
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
        public void SendReloadHalloweenRank()
        {
            GSPacketIn gSPacketIn = new GSPacketIn(90);
            gSPacketIn.WriteByte(5);
            this.method_4(gSPacketIn);
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
                this.method_5(gSPacketIn, null);
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
            this.method_4(pkg);
        }
        public CenterServer(CenterServerConfig config)
        {

            this.string_0 = "5498628";
            this.random_0 = new System.Random();
            this.int_1 = 20;

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
