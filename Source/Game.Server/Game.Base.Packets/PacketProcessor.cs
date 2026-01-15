namespace Game.Base.Packets
{
    using Game.Base;
    using Game.Base.Events;
    using Game.Server;
    using Game.Server.Packets.Client;
    using log4net;
    using System;
    using System.Reflection;
    using System.Threading;

    public class PacketProcessor
    {
        private static readonly ILog log;
        protected IPacketHandler m_activePacketHandler;
        protected GameClient m_client;
        protected int m_handlerThreadID;
        protected static readonly IPacketHandler[] m_packetHandlers;

        static PacketProcessor()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            m_packetHandlers = new IPacketHandler[512]; // packet sýnýrý 
        }

        public PacketProcessor(GameClient client)
        {
            this.m_client = client;
        }

        public void HandlePacket(GSPacketIn packet)
        {
            GSPacketIn @in = packet;
            int code = @in.Code;
            Statistics.BytesIn += packet.Length;
            Statistics.PacketsIn += 1L;

            IPacketHandler handler = null;
            if (code < m_packetHandlers.Length)
            {
                handler = m_packetHandlers[code];
                if (m_packetHandlers.GetType().FullName != "Game.Server.Packets.Client.QuestAddHandler")
                {
                    Console.ForegroundColor = ConsoleColor.Cyan;
                    Console.WriteLine("[-" + ((Game.Server.Packets.ePackageType)code) + "-] " + m_packetHandlers.GetType().FullName + " :=> Pack : " + code);
                    Console.ResetColor();
                }
                try
                {
                    handler.ToString();
                }
                catch
                {
                    Console.WriteLine("______________ERROR______________");
                    Console.WriteLine(string.Concat(new object[] { "___ Received code: ", code, " <", string.Format("0x{0:x}", code), "> ____" }));
                    Console.WriteLine("_________________________________");
                }
            }
            else if (log.IsErrorEnabled)
            {
                log.ErrorFormat("Received packet code is outside of m_packetHandlers array bounds! " + this.m_client.ToString(), new object[0]);
                log.Error(Marshal.ToHexDump(string.Format("===> <{2}> Packet 0x{0:X2} (0x{1:X2}) length: {3} (ThreadId={4})", new object[] { code, code ^ 0xa8, this.m_client.TcpEndpoint, packet.Length, Thread.CurrentThread.ManagedThreadId }), packet.Buffer));
            }
            if (handler != null)
            {
                long tickCount = Environment.TickCount;
                try
                {
                    if ((this.m_client != null))
                    {
                        if (packet != null)
                        {
                            if (this.m_client.TcpEndpoint != "not connected")
                            {
                                handler.HandlePacket(this.m_client, packet);
                            }
                            else
                                m_client.Disconnect();
                        }
                        else
                            m_client.Disconnect();

                    }
                    else
                        m_client.Disconnect();
                }
                catch (Exception exception)
                {
                    if (log.IsErrorEnabled)
                    {
                        string tcpEndpoint = this.m_client.TcpEndpoint;
                        log.Error("Error while processing packet (handler=" + handler.GetType().FullName + "  client: " + tcpEndpoint + ")", exception);
                        log.Error(Marshal.ToHexDump("Package Buffer:", packet.Buffer, 0, packet.Length));
                    }
                }
                long num3 = Environment.TickCount - tickCount;
                this.m_activePacketHandler = null;
                if (log.IsDebugEnabled)
                {
                    log.Debug("Package process Time:" + num3 + "ms!");
                }
                if (num3 > 0x5dcL)
                {
                    string str2 = this.m_client.TcpEndpoint;
                    if (log.IsWarnEnabled)
                    {
                        log.Warn(string.Concat(new object[] { "(", str2, ") Handle packet Thread ", Thread.CurrentThread.ManagedThreadId, " ", handler, " took ", num3, "ms!" }));
                    }
                }
            }
        }

        [ScriptLoadedEvent]
        public static void OnScriptCompiled(RoadEvent ev, object sender, EventArgs args)
        {
            Array.Clear(m_packetHandlers, 0, m_packetHandlers.Length);
            int num = SearchPacketHandlers("v168", Assembly.GetAssembly(typeof(GameServer)));
            if (log.IsInfoEnabled)
            {
                log.Info("PacketProcessor: Loaded " + num + " handlers from GameServer Assembly!");
            }
        }

        public static void RegisterPacketHandler(int packetCode, IPacketHandler handler)
        {
            m_packetHandlers[packetCode] = handler;
        }

        protected static int SearchPacketHandlers(string version, Assembly assembly)
        {
            int num = 0;
            foreach (Type type in assembly.GetTypes())
            {
                if (type.IsClass && (type.GetInterface("Game.Server.Packets.Client.IPacketHandler") != null))
                {
                    PacketHandlerAttribute[] customAttributes = (PacketHandlerAttribute[])type.GetCustomAttributes(typeof(PacketHandlerAttribute), true);
                    if (customAttributes.Length > 0)
                    {
                        num++;
                        RegisterPacketHandler(customAttributes[0].Code, (IPacketHandler)Activator.CreateInstance(type));
                    }
                }
            }
            return num;
        }
    }
}
