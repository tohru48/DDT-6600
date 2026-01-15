namespace Game.Base
{
    using log4net;
    using System;
    using System.Net;
    using System.Net.Sockets;
    using System.Reflection;
    using System.Threading;

    public class BaseConnector : BaseClient
    {
        private bool _autoReconnect;
        private IPEndPoint _remoteEP;
        private SocketAsyncEventArgs e;
        private static readonly ILog log;
        private static readonly int RECONNECT_INTERVAL;
        private System.Threading.Timer timer;

        static BaseConnector()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            RECONNECT_INTERVAL = 0x2710;
        }

        public BaseConnector(string ip, int port, bool autoReconnect, byte[] readBuffer, byte[] sendBuffer)
            : base(readBuffer, sendBuffer)
        {
            this._remoteEP = new IPEndPoint(IPAddress.Parse(ip), port);
            this._autoReconnect = autoReconnect;
            this.e = new SocketAsyncEventArgs();
        }

        public bool Connect()
        {
            bool flag;
            try
            {
                base.m_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                base.m_readBufEnd = 0;
                base.m_sock.Connect(this._remoteEP);
                log.InfoFormat("Connected to {0}", this._remoteEP);
                this.OnConnect();
                base.ReceiveAsync();
                return true;
            }
            catch
            {
                log.ErrorFormat("Connect {0} failed!", this._remoteEP);
                base.m_sock = null;
                flag = false;
            }
            return flag;
        }

        private static void RetryTimerCallBack(object target)
        {
            BaseConnector connector = target as BaseConnector;
            if (connector != null)
            {
                connector.TryReconnect();
            }
            else
            {
                log.Error("BaseConnector retryconnect timer return NULL!");
            }
        }

        private void TryReconnect()
        {
            if (this.Connect())
            {
                if (this.timer != null)
                {
                    this.timer.Dispose();
                    this.timer = null;
                }
                base.ReceiveAsync();
            }
            else
            {
                log.ErrorFormat("Reconnect {0} failed:", this._remoteEP);
                log.ErrorFormat("Retry after {0} ms!", RECONNECT_INTERVAL);
                if (this.timer == null)
                {
                    this.timer = new System.Threading.Timer(new TimerCallback(BaseConnector.RetryTimerCallBack), this, -1, -1);
                }
                this.timer.Change(RECONNECT_INTERVAL, -1);
            }
        }

        public IPEndPoint RemoteEP
        {
            get
            {
                return this._remoteEP;
            }
        }
    }
}
