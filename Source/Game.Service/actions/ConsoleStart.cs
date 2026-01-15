using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Collections;
using System.IO;
using Game.Server;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameUtils;
using System.Runtime.InteropServices;
using Game.Server.Managers;
using System.Threading;
using Game.Server.Packets;
using Bussiness.Managers;
using Bussiness;
using Game.Server.GameObjects;
using Game.Server.Rooms;
using Game.Logic;
using Game.Server.Games;
using Game.Server.Battle;
using Game.Server.Packets.Server;
using Game.Server.Commands;
using Game.Base;

namespace Game.Service.actions
{
    /// <summary>
    /// Handles 
    /// </summary>
    public class ConsoleStart : IAction
    {
        /// <summary>
        /// Defines a logger for this class
        /// </summary>
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Returns the name of this action
        /// </summary>
        public string Name
        {
            get { return "--start"; }
        }

        /// <summary>
        /// Returns the syntax of this action
        /// </summary>
        public string Syntax
        {
            get { return "--start [-config=./config/serverconfig.xml]"; }
        }

        /// <summary>
        /// Returns the description of this action
        /// </summary>
        /// 

        public string Description
        {
            get { return "Starts the DOL server in console mode"; }
        }

        /// <summary>
        /// Handles the server action
        /// </summary>
        /// <param name="parameters"></param>
        public void OnAction(Hashtable parameters)
        {
            Console.Title = "BombomHelper [6.6.0] || [Game.Service]";
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine("--------------------------Game Service - Version 6.6.0 | By BombomHelper Team！--------------------------");
            Console.ForegroundColor = ConsoleColor.Cyan;
            Console.WriteLine(">>>>>>  Developers : ASUNA && TigerMan");
            Console.WriteLine(">>>>>>  Release Date : 1 Aralık 2025");
            Console.ForegroundColor = ConsoleColor.Green;
            GameServer.CreateInstance(new GameServerConfig());
            GameServer.Instance.Start();
            GameServer.KeepRunning = true;
            Console.WriteLine("Server started!");
            ConsoleClient client = new ConsoleClient();
            while (GameServer.KeepRunning)
            {
                try
                {
                    handler = ConsoleCtrHandler;
                    SetConsoleCtrlHandler(handler, true);

                    Console.Write("> ");
                    string line = Console.ReadLine();
                    string[] para = line.Split(' ');
                    switch (para[0])
                    {
                        case "gmprop":
                            GameProperties.Refresh();
                            Console.WriteLine("GameProperties is Refreshed!");
                            break;

                        case "exit":
                            GameServer.KeepRunning = false;
                            break;
                        case "cp":
                            GameClient[] clients = GameServer.Instance.GetAllClients();
                            int clientCount = clients == null ? 0 : clients.Length;

                            GamePlayer[] players = WorldMgr.GetAllPlayers();
                            int playerCount = players == null ? 0 : players.Length;
                            List<BaseRoom> rooms = RoomMgr.GetAllUsingRoom();
                            int roomCount = 0;
                            int gameCount = 0;
                            foreach (BaseRoom r in rooms)
                            {
                                if (!r.IsEmpty)
                                {
                                    roomCount++;
                                    if (r.IsPlaying)
                                    {
                                        gameCount++;
                                    }
                                }
                            }

                            double memoryCount = GC.GetTotalMemory(false);
                            Console.WriteLine(string.Format("Total Clients/Players:{0}/{1}", clientCount, playerCount));
                            Console.WriteLine(string.Format("Total Rooms/Games:{0}/{1}", roomCount, gameCount));
                            Console.WriteLine(string.Format("Total Momey Used:{0} MB", memoryCount / 1024 / 1024));
                            break;
                        case "shutdown":
                            _count = 6;
                            _timer = new Timer(ShutDownCallBack, null, 0, 60000);
                            break;

                        case "clear":
                            Console.Clear();
                            break;
                        case "updategame":
                            if (BallMgr.ReLoad())
                                Console.WriteLine("Ball info is Reload!");
                            else
                                Console.WriteLine("Ball info is Error!");
                            if (MapMgr.ReLoadMap())
                                Console.WriteLine("Map info is Reload!");
                            else
                                Console.WriteLine("Map info is Error!");
                            if (MapMgr.ReLoadMapServer())
                                Console.WriteLine("mapserver info is Reload!");
                            else
                                Console.WriteLine("mapserver info is Error!");
                            if (PropItemMgr.Reload())
                                Console.WriteLine("prop info is Reload!");
                            else
                                Console.WriteLine("prop info is Error!");
                            if (ItemMgr.ReLoad())
                                Console.WriteLine("item info is Reload!");
                            else
                                Console.WriteLine("item info is Error!");
                            if (ShopMgr.ReLoad())
                                Console.WriteLine("shop info is Reload!");
                            else
                                Console.WriteLine("shop info is Error!");
                            if (QuestMgr.ReLoad())
                                Console.WriteLine("quest info is Reload!");
                            else
                                Console.WriteLine("quest info is Error!");
                            if (FusionMgr.ReLoad())
                                Console.WriteLine("fusion info is Reload!");
                            else
                                Console.WriteLine("fusion info is Error!");
                            if (ConsortiaMgr.ReLoad())
                                Console.WriteLine("consortiaMgr info is Reload!");
                            else
                                Console.WriteLine("consortiaMgr info is Error!");
                            if (RateMgr.ReLoad())
                                Console.WriteLine("Rate Rate is Reload!");
                            else
                                Console.WriteLine("Rate Rate is Error!");
                            if (FightRateMgr.ReLoad())
                                Console.WriteLine("FightRateMgr is Reload!");
                            else
                                Console.WriteLine("FightRateMgr is Error!");
                            if (AwardMgr.ReLoad())
                                Console.WriteLine("dailyaward is Reload!");
                            else
                                Console.WriteLine("dailyaward is Error!");
                            if (LanguageMgr.Reload(""))
                                Console.WriteLine("language is Reload!");
                            else
                                Console.WriteLine("language is Error!");
                            break;
                        case "nickname":
                            Console.WriteLine("Please enter the nickname");
                            string nickname = Console.ReadLine();
                            string state = WorldMgr.GetPlayerStringByPlayerNickName(nickname);
                            Console.WriteLine(state);
                            break;
                        default:
                            if (line.Length <= 0) break;
                            if (line[0] == '/')
                            {
                                line = line.Remove(0, 1);
                                line = line.Insert(0, "&");
                            }

                            try
                            {
                                bool res = CommandMgr.HandleCommandNoPlvl(client, line);
                                if (!res)
                                {
                                    Console.WriteLine("Unknown command: " + line);
                                }
                            }
                            catch (Exception e)
                            {
                                Console.WriteLine(e.ToString());
                            }
                            break;
                    }

                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex);
                }
            }

            if (GameServer.Instance != null)
                GameServer.Instance.Stop();

            LogManager.Shutdown();
        }

        private static Timer _timer;
        private static int _count;

        private static void ShutDownCallBack(object state)
        {
            _count--;
            Console.WriteLine($"Server will shutdown after {_count} mins!");
            GameClient[] allClients = GameServer.Instance.GetAllClients();
            GameClient[] array = allClients;
            foreach (GameClient c in array)
            {
                if (c.Out != null)
                {
                    c.Out.SendMessage(eMessageType.GM_NOTICE, string.Format("{0}{1}{2}", LanguageMgr.GetTranslation("Game.Service.actions.ShutDown1"), _count, LanguageMgr.GetTranslation("Game.Service.actions.ShutDown2")));
                }
            }
            if (_count == 0)
            {
                _timer.Dispose();
                _timer = null;
                foreach (GamePlayer allplayer in WorldMgr.GetAllPlayers())
                {
                    allplayer.Disconnect();
                }
                GameServer.Instance.Stop();
                Console.WriteLine("Server has stopped!");
                GameServer.KeepRunning = false;
                Environment.Exit(0);
                return;
            }
        }


        [DllImport("kernel32.dll", CallingConvention = CallingConvention.StdCall)]
        private static extern int SetConsoleCtrlHandler(ConsoleCtrlDelegate HandlerRoutine, bool add);

        private static ConsoleCtrlDelegate handler;

        private delegate int ConsoleCtrlDelegate(ConsoleEvent ctrlType);

        private static int ConsoleCtrHandler(ConsoleEvent e)
        {
            SetConsoleCtrlHandler(handler, add: false);
            if (GameServer.Instance != null)
            {
                GameServer.Instance.Stop();
            }
            return 0;
        }

        enum ConsoleEvent
        {
            Ctrl_C,
            Ctrl_Break,
            Close,
            Logoff,
            Shutdown
        }
    }
}
