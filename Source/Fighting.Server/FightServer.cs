// Decompiled with JetBrains decompiler
// Type: Fighting.Server.FightServer
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

using Bussiness;
using Bussiness.Managers;
using Fighting.Server.Games;
using Fighting.Server.Rooms;
using Game.Base;
using Game.Base.Events;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Protocol;
using Game.Server.Managers;
using log4net;
using log4net.Config;
using SqlDataProvider.Data;
using System;
using System.IO;
using System.Net;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Fighting.Server
{
    public class FightServer : BaseServer
    {
        private static readonly ILog ilog_1 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private FightServerConfig fightServerConfig_0;
        private bool bool_0;
        private static bool bool_1 = false;
        private System.Threading.Timer timer_0;
        private static FightServer fightServer_0;

        public FightServerConfig Configuration => this.fightServerConfig_0;

        public static FightServer Instance => FightServer.fightServer_0;

        protected override BaseClient GetNewClient() => (BaseClient)new ServerClient(this);

        public override bool Start()
        {
            if (this.bool_0)
                return false;
            bool flag;
            try
            {
                this.bool_0 = true;
                Thread.CurrentThread.Priority = ThreadPriority.Normal;
                AppDomain.CurrentDomain.UnhandledException += new UnhandledExceptionEventHandler(this.method_2);
                GameProperties.Refresh();
                if (!this.InitComponent(this.InitSocket(IPAddress.Parse(this.fightServerConfig_0.Ip), this.fightServerConfig_0.Port), "InitSocket Port:" + (object)this.fightServerConfig_0.Port))
                    flag = false;
                else if (!this.InitComponent(this.RecompileScripts(), "Recompile Scripts"))
                    flag = false;
                else if (!this.InitComponent(this.StartScriptComponents(), "Script components"))
                    flag = false;
                else if (!this.InitComponent(ProxyRoomMgr.Setup(), "RoomMgr.Setup"))
                    flag = false;
                else if (!this.InitComponent(GameMgr.Setup(0, 4), "GameMgr.Setup"))
                    flag = false;
                else if (!this.InitComponent(MapMgr.Init(), "MapMgr Init"))
                    flag = false;
                else if (!this.InitComponent(ItemMgr.Init(), "ItemMgr Init"))
                    flag = false;
                else if (!this.InitComponent(PropItemMgr.Init(), "PropItemMgr Init"))
                    flag = false;
                else if (!this.InitComponent(PetMgr.Init(), "PetMgr Init"))
                    flag = false;
                else if (!this.InitComponent(MountMgr.Init(), "MountMgr Init"))
                    flag = false;
                else if (!this.InitComponent(BallMgr.Init(), "BallMgr Init"))
                    flag = false;
                else if (!this.InitComponent(BallConfigMgr.Init(), "BallConfigMgr Init"))
                    flag = false;
                else if (!this.InitComponent(DropMgr.Init(), "DropMgr Init"))
                    flag = false;
                else if (!this.InitComponent(NPCInfoMgr.Init(), "NPCInfoMgr Init"))
                    flag = false;
                else if (!this.InitComponent(WindMgr.Init(), "WindMgr Init"))
                    flag = false;
                else if (!this.InitComponent(GoldEquipMgr.Init(), "GoldEquipMgr Init"))
                    flag = false;
                else if (!this.InitComponent(LanguageMgr.Setup(""), "LanguageMgr Init"))
                {
                    flag = false;
                }
                else
                {
                    GameEventMgr.Notify((RoadEvent)ScriptEvent.Loaded);
                    if (!this.InitComponent(base.Start(), "base.Start()"))
                    {
                        flag = false;
                    }
                    else
                    {
                        this.InitGlobalTimers();
                        ProxyRoomMgr.Start();
                        GameMgr.Start();
                        GameEventMgr.Notify((RoadEvent)GameServerEvent.Started, (object)this);
                        GC.Collect(GC.MaxGeneration);
                        FightServer.ilog_1.Info((object)"GameServer is now open for connections!");
                        this.SaveRemote(this.fightServerConfig_0.Port, 3, "Running...");
                        flag = true;
                    }
                }
            }
            catch (Exception ex)
            {
                FightServer.ilog_1.Error((object)"Failed to start the server", ex);
                flag = false;
            }
            return flag;
        }

        public void SaveRemote(int port, int status, string test)
        {
            if (!GameProperties.RemoteEnable)
                return;
            using (RemoteBussiness remoteBussiness = new RemoteBussiness())
                remoteBussiness.UpdateServer(port, status, test);
        }

        private void method_2(object sender, UnhandledExceptionEventArgs e)
        {
            FightServer.ilog_1.Fatal((object)("Unhandled exception!\n" + e.ExceptionObject.ToString()));
            if (!e.IsTerminating)
                return;
            LogManager.Shutdown();
        }

        protected bool InitComponent(bool componentInitState, string text)
        {
            FightServer.ilog_1.Info((object)(text + ": " + (object)componentInitState));
            if (!componentInitState)
                this.Stop();
            return componentInitState;
        }

        public bool RecompileScripts()
        {
            string str = "Game.Base.dll,Game.Logic.dll,SqlDataProvider.dll,Bussiness.dll,System.Drawing.dll";
            if (!FightServer.bool_1)
            {
                string path = this.Configuration.RootDirectory + Path.DirectorySeparatorChar.ToString() + "scripts";
                if (!Directory.Exists(path))
                    Directory.CreateDirectory(path);
                string[] asm_names = str.Split(',');
                FightServer.bool_1 = ScriptMgr.CompileScripts(false, path, this.Configuration.ScriptCompilationTarget, asm_names);
            }
            return FightServer.bool_1;
        }

        protected bool StartScriptComponents()
        {
            bool flag;
            try
            {
                ScriptMgr.InsertAssembly(typeof(FightServer).Assembly);
                ScriptMgr.InsertAssembly(typeof(BaseGame).Assembly);
                foreach (Assembly script in ScriptMgr.Scripts)
                {
                    GameEventMgr.RegisterGlobalEvents(script, typeof(GameServerStartedEventAttribute), (RoadEvent)GameServerEvent.Started);
                    GameEventMgr.RegisterGlobalEvents(script, typeof(GameServerStoppedEventAttribute), (RoadEvent)GameServerEvent.Stopped);
                    GameEventMgr.RegisterGlobalEvents(script, typeof(ScriptLoadedEventAttribute), (RoadEvent)ScriptEvent.Loaded);
                    GameEventMgr.RegisterGlobalEvents(script, typeof(ScriptUnloadedEventAttribute), (RoadEvent)ScriptEvent.Unloaded);
                }
                FightServer.ilog_1.Info((object)"Registering global event handlers: true");
                flag = true;
            }
            catch (Exception ex)
            {
                FightServer.ilog_1.Error((object)nameof(StartScriptComponents), ex);
                flag = false;
            }
            return flag;
        }

        public bool InitGlobalTimers()
        {
            int num = 60000;
            if (this.timer_0 == null)
                this.timer_0 = new System.Threading.Timer(new TimerCallback(this.ScanRemoteProc), (object)null, num, num);
            else
                this.timer_0.Change(num, num);
            return true;
        }

        protected void ScanRemoteProc(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                ThreadPriority priority = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                if (GameProperties.RemoteEnable)
                {
                    using (RemoteBussiness remoteBussiness = new RemoteBussiness())
                    {
                        RemoteServerInfo[] allRemoteServer = remoteBussiness.GetAllRemoteServer();
                        int num1 = 0;
                        int num2 = 0;
                        foreach (RemoteServerInfo remoteServerInfo in allRemoteServer)
                        {
                            if (remoteServerInfo.ProcessID == 3 && remoteServerInfo.ZoneID == this.fightServerConfig_0.ZoneId && remoteServerInfo.UserID == this.fightServerConfig_0.ServerID)
                            {
                                ++num1;
                                if (remoteServerInfo.ProcessStatus == 0)
                                    ++num2;
                            }
                        }
                        if (num1 + num2 > 0 && num1 == num2)
                            this.Stop();
                    }
                }
                Thread.CurrentThread.Priority = priority;
                int num = Environment.TickCount - tickCount;
            }
            catch
            {
            }
        }

        public override void Stop()
        {
            if (!this.bool_0)
                return;
            try
            {
                this.bool_0 = false;
                if (this.timer_0 != null)
                    this.timer_0.Dispose();
                GameMgr.Stop();
                ProxyRoomMgr.Stop();
                this.SaveRemote(this.fightServerConfig_0.Port, 0, "Stopped");
            }
            catch (Exception ex)
            {
                FightServer.ilog_1.Error((object)"Server stopp error:", ex);
            }
            finally
            {
                base.Stop();
            }
        }

        public ServerClient[] GetAllClients()
        {
            ServerClient[] allClients = (ServerClient[])null;
            lock (this._clients.SyncRoot)
            {
                allClients = new ServerClient[this._clients.Count];
                this._clients.Keys.CopyTo((Array)allClients, 0);
            }
            return allClients;
        }

        public void method_3(GSPacketIn pkg) => this.method_4(pkg, (ServerClient)null);

        public void method_4(GSPacketIn pkg, ServerClient except)
        {
            ServerClient[] allClients = this.GetAllClients();
            if (allClients == null)
                return;
            foreach (ServerClient serverClient in allClients)
            {
                if (serverClient != except)
                    serverClient.SendTCP(pkg);
            }
        }

        private FightServer(FightServerConfig config) => this.fightServerConfig_0 = config;

        public static void CreateInstance(FightServerConfig config)
        {
            if (FightServer.fightServer_0 != null)
                return;
            FileInfo configFile = new FileInfo(config.LogConfigFile);
            if (!configFile.Exists)
                ResourceUtil.ExtractResource(configFile.Name, configFile.FullName, Assembly.GetAssembly(typeof(FightServer)));
            XmlConfigurator.ConfigureAndWatch(configFile);
            FightServer.fightServer_0 = new FightServer(config);
        }
    }
}
