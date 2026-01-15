using System;
using System.Collections;
using System.IO;
using System.Net;
using System.Reflection;
using System.Text;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Base;
using Game.Base.Events;
using Game.Logic;
using Game.Logic.Protocol;
using Game.Server.Battle;
using Game.Server.DragonBoat;
using Game.Server.GameObjects;
using Game.Server.Games;
using Game.Server.GypsyShop;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.RingStation;
using Game.Server.Rooms;
using Game.Server.Statics;
using log4net;
using log4net.Config;
using SqlDataProvider.Data;

namespace Game.Server
{
	public class GameServer : BaseServer
	{
		public static readonly ILog log;

		public static readonly string Edition;

		public static bool KeepRunning;

		private static GameServer gameServer_0;

		private bool bool_0;

		private GameServerConfig gameServerConfig_0;

		private LoginServerConnector loginServerConnector_0;

		private LoginServerConnector loginServerConnector_1;

		private Queue queue_0;

		private bool bool_1;

		private static int int_1;

		private static int int_2;

		private static bool bool_2;

		private Timer timer_0;

		private int int_3;

		protected Timer m_saveDbTimer;

		protected Timer m_pingCheckTimer;

		protected Timer m_saveRecordTimer;

		protected Timer m_buffScanTimer;

		protected Timer m_qqTipScanTimer;

		protected Timer m_bagMailScanTimer;

		public static GameServer Instance => gameServer_0;

		public GameServerConfig Configuration => gameServerConfig_0;

		public LoginServerConnector LoginServer => loginServerConnector_0;

		public LoginServerConnector LoginCrossServer => loginServerConnector_1;

		public int PacketPoolSize => queue_0.Count;

		public static void CreateInstance(GameServerConfig config)
		{
			if (gameServer_0 == null)
			{
				FileInfo fileInfo = new FileInfo(config.LogConfigFile);
				if (!fileInfo.Exists)
				{
					ResourceUtil.ExtractResource(fileInfo.Name, fileInfo.FullName, Assembly.GetAssembly(typeof(GameServer)));
				}
				XmlConfigurator.ConfigureAndWatch(fileInfo);
				gameServer_0 = new GameServer(config);
			}
		}

		protected GameServer(GameServerConfig config)
		{
			int_3 = 6;
			gameServerConfig_0 = config;
			if (log.IsDebugEnabled)
			{
				log.Debug("Current directory is: " + Directory.GetCurrentDirectory());
				log.Debug("Gameserver root directory is: " + Configuration.RootDirectory);
				log.Debug("Changing directory to root directory");
			}
			Directory.SetCurrentDirectory(Configuration.RootDirectory);
		}

		private bool method_3()
		{
			int num = Configuration.MaxClientCount * 3;
			queue_0 = new Queue(num);
			for (int i = 0; i < num; i++)
			{
				queue_0.Enqueue(new byte[8192]);
			}
			if (log.IsDebugEnabled)
			{
				log.DebugFormat("allocated packet buffers: {0}", num.ToString());
			}
			return true;
		}

		public byte[] AcquirePacketBuffer()
		{
			lock (queue_0.SyncRoot)
			{
				if (queue_0.Count > 0)
				{
					return (byte[])queue_0.Dequeue();
				}
			}
			log.Warn("packet buffer pool is empty!");
			return new byte[8192];
		}

		public void ReleasePacketBuffer(byte[] buf)
		{
			if (buf != null && GC.GetGeneration(buf) >= GC.MaxGeneration)
			{
				lock (queue_0.SyncRoot)
				{
					queue_0.Enqueue(buf);
				}
			}
		}

		protected override BaseClient GetNewClient()
		{
			return new GameClient(this, AcquirePacketBuffer(), AcquirePacketBuffer());
		}

		public new GameClient[] GetAllClients()
		{
			GameClient[] array = null;
			lock (_clients.SyncRoot)
			{
				array = new GameClient[_clients.Count];
				_clients.Keys.CopyTo(array, 0);
			}
			return array;
		}

		public override bool Start()
		{
			if (bool_0)
			{
				return false;
			}
			bool result;
			try
			{
				AppDomain.CurrentDomain.UnhandledException += RsVedOvFry;
				Thread.CurrentThread.Priority = ThreadPriority.Normal;
				GameProperties.Refresh();
				if (!InitComponent(RecompileScripts(), "Recompile Scripts"))
				{
					result = false;
				}
				else if (!InitComponent(StartScriptComponents(), "Script components"))
				{
					result = false;
				}
				else if (!InitComponent(GameProperties.EDITION == Edition, "Edition: " + Edition))
				{
					result = false;
				}
				else if (!InitComponent(InitSocket(IPAddress.Parse(Configuration.Ip), Configuration.Port), "InitSocket Port: " + Configuration.Port))
				{
					result = false;
				}
				else if (!InitComponent(method_3(), "AllocatePacketBuffers()"))
				{
					result = false;
				}
				else if (!InitComponent(LogMgr.Setup(Configuration.GAME_TYPE, Configuration.ServerID, Configuration.AreaId), "LogMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(WorldMgr.Init(), "WorldMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(MapMgr.Init(), "MapMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ItemMgr.Init(), "ItemMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ItemBoxMgr.Init(), "ItemBox Init"))
				{
					result = false;
				}
				else if (!InitComponent(AccumulActiveLoginMgr.Init(), "AccumulActiveLoginMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(BallMgr.Init(), "BallMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ExerciseMgr.Init(), "ExerciseMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(LevelMgr.Init(), "levelMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(BallConfigMgr.Init(), "BallConfigMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(FusionMgr.Init(), "FusionMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(AwardMgr.Init(), "AwardMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ActivityQuestMgr.Init(), "ActivityQuestMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ActivityHalloweenItemsMgr.Init(), "ActivityHalloweenItemsMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ChargeSpendRewardTemplateMgr.Init(), "ChargeSpendRewardTemplateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(AchievementMgr.Init(), "AchievementMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(LotteryShowTemplateMgr.Init(), "LotteryShowTemplateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(TreeTemplateMgr.Init(), "TreeTemplateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(NewTitleMgr.Init(), "NewTitleMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(PetMoePropertyMgr.Init(), "PetMoePropertyMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(RankTemplateMgr.Init(), "RankTemplateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(DailyLeagueAwardMgr.Init(), "DailyLeagueAwardMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(SearchGoodsMgr.Init(), "SearchGoodsMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(SuitMgr.Init(), "SuitMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(DiceGameAwardMgr.Init(), "DiceGameAwardMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(EveryDayActiveMgr.Init(), "EveryDayActiveMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(GmActivityMgr.Init(), "GmActivityMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(FightLabDropItemMgr.Init(), "FightLabDropItemMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(HelpGameRewardMgr.Init(), "HelpGameRewardMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(MagicItemTemplateMgr.Init(), "MagicItemTemplateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(AllQuestionsMgr.Init(), "AllQuestionsMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ChargeActiveTemplateMgr.Init(), "ChargeActiveTemplateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(NPCInfoMgr.Init(), "NPCInfoMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(MissionInfoMgr.Init(), "MissionInfoMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(MissionEnergyMgr.Init(), "MissionEnergyInfoMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(PveInfoMgr.Init(), "PveInfoMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(DropMgr.Init(), "Drop Init"))
				{
					result = false;
				}
				else if (!InitComponent(AvatarColectionMgr.Init(), "AvatarColectionMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(FightRateMgr.Init(), "FightRateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(RefineryMgr.Init(), "RefineryMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(StrengthenMgr.Init(), "StrengthenMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(PropItemMgr.Init(), "PropItemMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ShopMgr.Init(), "ShopMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(QuestMgr.Init(), "QuestMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ActiveMgr.Init(), "ActiveMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(GypsyShopMgr.Init(), "GypsyShopMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ConsortiaMgr.Init(), "ConsortiaMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(ConsortiaExtraMgr.Init(), "ConsortiaExtraMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(RateMgr.Init(Configuration), "ExperienceRateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(WindMgr.Init(), "WindMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(CardMgr.Init(), "CardMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(PetMgr.Init(), "PetMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(GoldEquipMgr.Init(), "GoldEquipMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(RuneMgr.Init(), "RuneMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(TotemMgr.Init(), "TotemMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(TotemHonorMgr.Init(), "TotemHonorMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(TreasureAwardMgr.Init(), "TreasureAwardMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(FairBattleRewardMgr.Init(), "FairBattleRewardMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(MagicStoneMgr.Init(), "MagicStoneMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(FightSpiritTemplateMgr.Init(), "FightSpiritTemplateMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(MacroDropMgr.Init(), "MacroDropMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(MarryRoomMgr.Init(), "MarryRoomMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(RankMgr.Init(), "RankMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(CommunalActiveMgr.Init(), "CommunalActiveMgr Setup"))
				{
					result = false;
				}
				else if (!InitComponent(QQTipsMgr.Init(), "QQTipsMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(LightriddleQuestMgr.Init(), "LightriddleQuestMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(WorldEventMgr.Init(), "WorldEventMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(SubActiveMgr.Init(), "SubActiveMgr Setup"))
				{
					result = false;
				}
				else if (!InitComponent(DiceLevelAwardMgr.Init(), "DiceLevelMgr Setup"))
				{
					result = false;
				}
				else if (!InitComponent(EventAwardMgr.Init(), "EventAwardMgr Setup"))
				{
					result = false;
				}
				else if (!InitComponent(ActiveSystermAwardMgr.Init(), "TreasurePuzzledMgr Setup"))
				{
					result = false;
				}
				else if (!InitComponent(MountMgr.Init(), "MountMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(CloudBuyLotteryMgr.Init(), "CloudBuyLotteryMgr Setup"))
				{
					result = false;
				}
				else if (!InitComponent(ActiveSystemMgr.Init(), "ActiveSystemMgr Setup"))
				{
					result = false;
				}
				else if (!InitComponent(LanguageMgr.Setup(""), "LanguageMgr Init"))
				{
					result = false;
				}
				else if (!InitComponent(RoomMgr.Setup(Configuration.MaxRoomCount), "RoomMgr.Setup"))
				{
					result = false;
				}
				else if (!InitComponent(GameMgr.Setup(Configuration.ServerID, GameProperties.BOX_APPEAR_CONDITION), "GameMgr.Start()"))
				{
					result = false;
				}
				else if (!InitComponent(BattleMgr.Setup(), "BattleMgr Setup"))
				{
					result = false;
				}
				else if (!InitComponent(RingStationMgr.Init(), "RingStation Int"))
				{
					result = false;
				}
				else if (!InitComponent(InitGlobalTimer(), "Init Global Timers"))
				{
					result = false;
				}
				else if (!InitComponent(LogMgr.Setup(1, Configuration.ServerID, Configuration.AreaId), "LogMgr Setup"))
				{
					result = false;
				}
				else
				{
					GameEventMgr.Notify(ScriptEvent.Loaded);
					if (!InitComponent(TsyekXnrx6(), "Login To CenterServer"))
					{
						result = false;
					}
					else if (!InitComponent(method_4(), "Login To CenterCrooszoneServer"))
					{
						result = false;
					}
					else
					{
						RoomMgr.Start();
						GameMgr.Start();
						BattleMgr.Start();
						MacroDropMgr.Start();
						if (!InitComponent(base.Start(), "base.Start()"))
						{
							result = false;
						}
						else
						{
							GameEventMgr.Notify(GameServerEvent.Started, this);
							UpdateUserData(Configuration.Port, 3, "Running...");
							GC.Collect(GC.MaxGeneration);
							if (log.IsInfoEnabled)
							{
								log.Info("GameServer is now open for connections!");
							}
							bool_0 = true;
							result = true;
						}
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Failed to start the server", exception);
				}
				result = false;
			}
			return result;
		}

		public void UpdateUserData(int port, int status, string test)
		{
			if (GameProperties.RemoteEnable)
			{
				using RemoteBussiness remoteBussiness = new RemoteBussiness();
				remoteBussiness.UpdateServer(port, status, test);
			}
			UpdateRenames();
		}

		public void UpdateRenames()
		{
			using AreaBussiness areaBussiness = new AreaBussiness();
			AreaConfigInfo[] allAreaConfig = areaBussiness.GetAllAreaConfig();
			AreaConfigInfo[] array = allAreaConfig;
			foreach (AreaConfigInfo areaConfigInfo in array)
			{
				using AreaPlayerBussiness areaPlayerBussiness = new AreaPlayerBussiness(areaConfigInfo);
				areaPlayerBussiness.UpdateRenames(areaConfigInfo.Catalog);
			}
		}

		private bool TsyekXnrx6()
		{
			loginServerConnector_0 = new LoginServerConnector(gameServerConfig_0.LoginServerIp, gameServerConfig_0.LoginServerPort, gameServerConfig_0.ServerID, gameServerConfig_0.ServerName, AcquirePacketBuffer(), AcquirePacketBuffer());
			loginServerConnector_0.Disconnected += method_5;
			return loginServerConnector_0.Connect();
		}

		private bool method_4()
		{
			loginServerConnector_1 = new LoginServerConnector(gameServerConfig_0.LoginCrosszoneServerIp, gameServerConfig_0.LoginCrosszoneServerPort, gameServerConfig_0.ServerID, gameServerConfig_0.ServerName, AcquirePacketBuffer(), AcquirePacketBuffer());
			loginServerConnector_1.Disconnected += method_6;
			return loginServerConnector_1.Connect();
		}

		private void method_5(BaseClient baseClient_0)
		{
			bool flag = bool_0;
			Stop();
			if (flag && int_1 > 0)
			{
				int_1--;
				log.Error("Center Server Disconnect! Stopping Server");
				log.ErrorFormat("Start the game server again after 1 second,and left try times:{0}", int_1);
				Thread.Sleep(1000);
				if (Start())
				{
					log.Error("Restart the game server success!");
				}
			}
			else
			{
				if (int_1 == 0)
				{
					log.ErrorFormat("Restart the game server failed after {0} times.", 4);
					log.Error("Server Stopped!");
				}
				LogManager.Shutdown();
			}
		}

		private void method_6(BaseClient baseClient_0)
		{
			if (!bool_0)
			{
				return;
			}
			if (int_2 > 0)
			{
				int_2--;
				log.Error("Center Cross Server Disconnect!");
				log.ErrorFormat("Start Reconect Center Cross Server again after 5 second");
				Thread.Sleep(5000);
				if (method_4())
				{
					log.Error("Restart conect Center Cross Server success!");
				}
			}
			else
			{
				int_2 = 5;
			}
		}

		private void RsVedOvFry(object sender, UnhandledExceptionEventArgs e)
		{
			try
			{
				log.Fatal("Unhandled exception!\n" + e.ExceptionObject.ToString());
				if (e.IsTerminating)
				{
					Stop();
				}
			}
			catch
			{
				try
				{
					using FileStream stream = new FileStream("c:\\testme.log", FileMode.Append, FileAccess.Write);
					using StreamWriter streamWriter = new StreamWriter(stream, Encoding.UTF8);
					streamWriter.WriteLine(e.ExceptionObject);
				}
				catch
				{
				}
			}
		}

		public bool RecompileScripts()
		{
			if (!bool_2)
			{
				string path = Configuration.RootDirectory + Path.DirectorySeparatorChar + "scripts";
				if (!Directory.Exists(path))
				{
					Directory.CreateDirectory(path);
				}
				string[] asm_names = Configuration.ScriptAssemblies.Split(',');
				bool_2 = ScriptMgr.CompileScripts(compileVB: false, path, Configuration.ScriptCompilationTarget, asm_names);
			}
			return bool_2;
		}

		protected bool StartScriptComponents()
		{
			bool result;
			try
			{
				if (log.IsInfoEnabled)
				{
					log.Info("Server rules: true");
				}
				ScriptMgr.InsertAssembly(typeof(GameServer).Assembly);
				ScriptMgr.InsertAssembly(typeof(BaseGame).Assembly);
				ScriptMgr.InsertAssembly(typeof(BaseServer).Assembly);
				ArrayList arrayList = new ArrayList(ScriptMgr.Scripts);
				foreach (Assembly item in arrayList)
				{
					GameEventMgr.RegisterGlobalEvents(item, typeof(GameServerStartedEventAttribute), GameServerEvent.Started);
					GameEventMgr.RegisterGlobalEvents(item, typeof(GameServerStoppedEventAttribute), GameServerEvent.Stopped);
					GameEventMgr.RegisterGlobalEvents(item, typeof(ScriptLoadedEventAttribute), ScriptEvent.Loaded);
					GameEventMgr.RegisterGlobalEvents(item, typeof(ScriptUnloadedEventAttribute), ScriptEvent.Unloaded);
				}
				if (log.IsInfoEnabled)
				{
					log.Info("Registering global event handlers: true");
				}
				return true;
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("StartScriptComponents", exception);
				}
				result = false;
			}
			return result;
		}

		protected bool InitComponent(bool componentInitState, string text)
		{
			if (bool_1)
			{
				log.Debug("Start Memory " + text + ": " + GC.GetTotalMemory(forceFullCollection: false) / 1024 / 1024);
			}
			if (log.IsInfoEnabled)
			{
				log.Info(text + ": " + componentInitState);
			}
			if (!componentInitState)
			{
				Stop();
			}
			if (bool_1)
			{
				log.Debug("Finish Memory " + text + ": " + GC.GetTotalMemory(forceFullCollection: false) / 1024 / 1024);
			}
			return componentInitState;
		}

		public override void Stop()
		{
			if (bool_0)
			{
				bool_0 = false;
				if (!MarryRoomMgr.UpdateBreakTimeWhereServerStop())
				{
					Console.WriteLine("Update BreakTime failed");
				}
				CloudBuyLotteryMgr.SaveCloudBuyLottery();
				WorldMgr.ScanBagMail();
				RoomMgr.Stop();
				GameMgr.Stop();
				ActiveSystemMgr.StopAllTimer();
				RingStationMgr.StopAllTimer();
				DragonBoatMgr.StopAllTimer();
				CloudBuyLotteryMgr.StopAllTimer();
				GypsyShopMgr.StopAllTimer();
				if (loginServerConnector_0 != null)
				{
					loginServerConnector_0.Disconnected -= method_5;
					loginServerConnector_0.Disconnect();
				}
				if (loginServerConnector_1 != null)
				{
					loginServerConnector_1.Disconnected -= method_5;
					loginServerConnector_1.Disconnect();
				}
				if (m_pingCheckTimer != null)
				{
					m_pingCheckTimer.Change(-1, -1);
					m_pingCheckTimer.Dispose();
					m_pingCheckTimer = null;
				}
				if (m_saveDbTimer != null)
				{
					m_saveDbTimer.Change(-1, -1);
					m_saveDbTimer.Dispose();
					m_saveDbTimer = null;
				}
				if (m_saveRecordTimer != null)
				{
					m_saveRecordTimer.Change(-1, -1);
					m_saveRecordTimer.Dispose();
					m_saveRecordTimer = null;
				}
				if (m_buffScanTimer != null)
				{
					m_buffScanTimer.Change(-1, -1);
					m_buffScanTimer.Dispose();
					m_buffScanTimer = null;
				}
				if (m_qqTipScanTimer != null)
				{
					m_qqTipScanTimer.Change(-1, -1);
					m_qqTipScanTimer.Dispose();
					m_qqTipScanTimer = null;
				}
				if (m_bagMailScanTimer != null)
				{
					m_bagMailScanTimer.Change(-1, -1);
					m_bagMailScanTimer.Dispose();
					m_bagMailScanTimer = null;
				}
				base.Stop();
				Thread.CurrentThread.Priority = ThreadPriority.BelowNormal;
				log.Info("Server Stopped!");
				Console.WriteLine("Server Stopped!");
			}
		}

		public void Shutdown()
		{
			gameServer_0.LoginServer.SendShutdown(isStoping: true);
			timer_0 = new Timer(method_7, null, 0, 60000);
		}

		private void method_7(object object_0)
		{
			try
			{
				int_3--;
				Console.WriteLine($"Server will shutdown after {int_3} mins!");
				GameClient[] allClients = gameServer_0.GetAllClients();
				GameClient[] array = allClients;
				foreach (GameClient gameClient in array)
				{
					if (gameClient.Out != null)
					{
						gameClient.Out.SendMessage(eMessageType.Normal, string.Format("{0}{1}{2}", LanguageMgr.GetTranslation("Game.Service.actions.ShutDown1"), int_3, LanguageMgr.GetTranslation("Game.Service.actions.ShutDown2")));
					}
				}
				if (int_3 == 0)
				{
					Console.WriteLine("Server has stopped!");
					gameServer_0.LoginServer.SendShutdown(isStoping: false);
					timer_0.Dispose();
					timer_0 = null;
					gameServer_0.Stop();
				}
			}
			catch (Exception message)
			{
				log.Error(message);
			}
		}

		public bool InitGlobalTimer()
		{
			int num = Configuration.DBSaveInterval * 60 * 1000;
			if (m_saveDbTimer == null)
			{
				m_saveDbTimer = new Timer(SaveTimerProc, null, num, num);
			}
			else
			{
				m_saveDbTimer.Change(num, num);
			}
			num = Configuration.PingCheckInterval * 60 * 1000;
			if (m_pingCheckTimer == null)
			{
				m_pingCheckTimer = new Timer(PingCheck, null, num, num);
			}
			else
			{
				m_pingCheckTimer.Change(num, num);
			}
			num = Configuration.SaveRecordInterval * 60 * 1000;
			if (m_saveRecordTimer == null)
			{
				m_saveRecordTimer = new Timer(SaveRecordProc, null, num, num);
			}
			else
			{
				m_saveRecordTimer.Change(num, num);
			}
			num = 60000;
			if (m_buffScanTimer == null)
			{
				m_buffScanTimer = new Timer(BuffScanTimerProc, null, num, num);
			}
			else
			{
				m_buffScanTimer.Change(num, num);
			}
			num = 300000;
			if (m_qqTipScanTimer == null)
			{
				m_qqTipScanTimer = new Timer(QQTipScanTimerProc, null, num, num);
			}
			else
			{
				m_qqTipScanTimer.Change(num, num);
			}
			num = 900000;
			if (m_bagMailScanTimer == null)
			{
				m_bagMailScanTimer = new Timer(BagMailScanTimerProc, null, num, num);
			}
			else
			{
				m_bagMailScanTimer.Change(num, num);
			}
			return true;
		}

		protected void PingCheck(object sender)
		{
			try
			{
				log.Info("Begin ping check....");
				long num = (long)Configuration.PingCheckInterval * 60L * 1000 * 1000 * 10;
				GameClient[] allClients = GetAllClients();
				if (allClients != null)
				{
					GameClient[] array = allClients;
					foreach (GameClient gameClient in array)
					{
						if (gameClient == null)
						{
							continue;
						}
						if (gameClient.IsConnected)
						{
							if (gameClient.Player != null)
							{
								gameClient.Out.SendPingTime(gameClient.Player);
								if (Class12.smethod_1() && Class12.int_0 == 0)
								{
									Class12.int_0++;
								}
							}
							else if (gameClient.PingTime + num < DateTime.Now.Ticks)
							{
								gameClient.Disconnect();
							}
						}
						else
						{
							gameClient.Disconnect();
						}
					}
				}
				log.Info("End ping check....");
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("PingCheck callback", exception);
				}
			}
			try
			{
				log.Info("Begin ping center check....");
				gameServer_0.LoginServer.SendPingCenter();
				log.Info("End ping center check....");
			}
			catch (Exception exception2)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("PingCheck center callback", exception2);
				}
			}
		}

		protected void SaveTimerProc(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Saving database...");
					log.Debug("Save ThreadId=" + Thread.CurrentThread.ManagedThreadId);
				}
				int num = 0;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				GamePlayer[] array = allPlayers;
				foreach (GamePlayer gamePlayer in array)
				{
					gamePlayer.SaveNewItemToDatabase();
					num++;
				}
				UpdateRenames();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Saving database complete!");
					log.Info("Saved all databases and " + num + " players in " + tickCount + "ms");
				}
				if (tickCount > 120000)
				{
					log.WarnFormat("Saved all databases and {0} players in {1} ms", num, tickCount);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SaveTimerProc", exception);
				}
			}
			finally
			{
				GameEventMgr.Notify(GameServerEvent.WorldSave);
			}
		}

		protected void SaveRecordProc(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Saving Record...");
					log.Debug("Save ThreadId=" + Thread.CurrentThread.ManagedThreadId);
				}
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				LogMgr.Save();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Saving Record complete!");
				}
				if (tickCount > 120000)
				{
					log.WarnFormat("Saved all Record  in {0} ms", tickCount);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SaveRecordProc", exception);
				}
			}
		}

		protected void BuffScanTimerProc(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Buff Scaning ...");
					log.Debug("BuffScan ThreadId=" + Thread.CurrentThread.ManagedThreadId);
				}
				int num = 0;
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				GamePlayer[] array = allPlayers;
				foreach (GamePlayer gamePlayer in array)
				{
					if (gamePlayer.BufferList != null)
					{
						gamePlayer.BufferList.Update();
						num++;
					}
					gamePlayer.Reset(saveToDb: false);
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("Buff Scan complete!");
					log.Info("Buff all " + num + " players in " + tickCount + "ms");
				}
				if (tickCount > 120000)
				{
					log.WarnFormat("Scan all Buff and {0} players in {1} ms", num, tickCount);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("BuffScanTimerProc", exception);
				}
			}
		}

		protected void QQTipScanTimerProc(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("QQTips Scaning ...");
				}
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				GClass1 qQtipsMessages = QQTipsMgr.GetQQtipsMessages();
				GamePlayer[] allPlayersNoGame = WorldMgr.GetAllPlayersNoGame();
				GamePlayer[] array = allPlayersNoGame;
				foreach (GamePlayer gamePlayer in array)
				{
					gamePlayer.Out.imethod_1(gamePlayer.PlayerId, qQtipsMessages);
				}
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("QQTips Scan complete!");
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("QQTipScanTimerProc", exception);
				}
			}
		}

		protected void BagMailScanTimerProc(object sender)
		{
			try
			{
				int tickCount = Environment.TickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("BagMail Scaning ...");
				}
				ThreadPriority priority = Thread.CurrentThread.Priority;
				Thread.CurrentThread.Priority = ThreadPriority.Lowest;
				WorldMgr.ScanBagMail();
				Thread.CurrentThread.Priority = priority;
				tickCount = Environment.TickCount - tickCount;
				if (log.IsInfoEnabled)
				{
					log.Info("BagMail Scan complete!");
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("BagMailScanTimerProc", exception);
				}
			}
		}

		static GameServer()
		{
			log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			Edition = "5498628";
			KeepRunning = false;
			gameServer_0 = null;
			int_1 = 4;
			int_2 = 5;
			bool_2 = false;
		}
	}
}
