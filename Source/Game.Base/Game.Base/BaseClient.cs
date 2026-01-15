namespace Game.Base
{
    using Game.Base.Packets;
    using log4net;
    using System;
    using System.Net.Sockets;
    using System.Reflection;
    using System.Threading;

    public class BaseClient
    {
        public bool IsClientPacketSended;
        private static readonly ILog log;
        private bool m_asyncPostSend;
        private bool m_encryted;
        private int m_isConnected;
        public StreamProcessor m_processor;
        protected int m_readBufEnd;
        protected byte[] m_readBuffer;
        protected byte[] m_sendBuffer;
        protected System.Net.Sockets.Socket m_sock;
        private bool m_strict;
        public int numPacketProcces;
        private SocketAsyncEventArgs rc_event;
        public byte[] RECEIVE_KEY;
        public byte[] SEND_KEY;

        public event ClientEventHandle Connected;

        public event ClientEventHandle Disconnected;

        static BaseClient()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        public BaseClient(byte[] readBuffer, byte[] sendBuffer)
        {
            this.IsClientPacketSended = true;
            this.m_readBuffer = readBuffer;
            this.m_sendBuffer = sendBuffer;
            this.m_readBufEnd = 0;
            this.rc_event = new SocketAsyncEventArgs();
            this.rc_event.Completed += new EventHandler<SocketAsyncEventArgs>(this.RecvEventCallback);
            this.m_processor = new StreamProcessor(this);
            this.m_encryted = false;
            this.m_strict = true;
        }

        protected void CloseConnections()
        {
            if (this.m_sock != null)
            {
                try
                {
                    this.m_sock.Shutdown(SocketShutdown.Both);
                }
                catch
                {
                }
                try
                {
                    this.m_sock.Close();
                }
                catch
                {
                }
            }
        }

        public virtual bool Connect(System.Net.Sockets.Socket connectedSocket)
        {
            this.m_sock = connectedSocket;
            if (!this.m_sock.Connected)
            {
                return false;
            }
            if (Interlocked.Exchange(ref this.m_isConnected, 1) == 0)
            {
                this.OnConnect();
            }
            return true;
        }

        public virtual void Disconnect()
        {
            try
            {
                if (Interlocked.Exchange(ref this.m_isConnected, 0) == 1)
                {
                    this.CloseConnections();
                    this.OnDisconnect();
                    this.rc_event.Dispose();
                    this.m_processor.Dispose();
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Exception", exception);
                }
            }
        }

        public virtual void DisplayMessage(string msg)
        {
        }

        protected virtual void OnConnect()
        {
            if ((Interlocked.Exchange(ref this.m_isConnected, 1) == 0) && (this.Connected != null))
            {
                this.Connected(this);
            }
        }

        protected virtual void OnDisconnect()
        {
            if (this.Disconnected != null)
            {
                this.Disconnected(this);
            }
        }

        public virtual void OnRecv(int num_bytes)
        {
            this.m_processor.ReceiveBytes(num_bytes);
        }

        public virtual void OnRecvPacket(GSPacketIn pkg)
        {
        }

        public void ReceiveAsync()
        {
            this.ReceiveAsyncImp(this.rc_event);
        }

        private void ReceiveAsyncImp(SocketAsyncEventArgs e)
        {
            if ((this.m_sock != null) && this.m_sock.Connected)
            {
                int length = this.m_readBuffer.Length;
                if (this.m_readBufEnd >= length)
                {
                    if (log.IsErrorEnabled)
                    {
                        log.Error(this.TcpEndpoint + " disconnected because of buffer overflow!");
                        log.Error(string.Concat(new object[] { "m_pBufEnd=", this.m_readBufEnd, "; buf size=", length }));
                        log.Error(this.m_readBuffer);
                    }
                    this.Disconnect();
                }
                else
                {
                    e.SetBuffer(this.m_readBuffer, this.m_readBufEnd, length - this.m_readBufEnd);
                    if (!this.m_sock.ReceiveAsync(e))
                    {
                        this.RecvEventCallback(this.m_sock, e);
                    }
                }
            }
            else
            {
                this.Disconnect();
            }
        }

        private void RecvEventCallback(object sender, SocketAsyncEventArgs e)
        {
            try
            {
                int bytesTransferred = e.BytesTransferred;
                if (bytesTransferred > 0)
                {
                    this.OnRecv(bytesTransferred);
                    this.ReceiveAsyncImp(e);
                }
                else
                {
                    log.InfoFormat("Disconnecting client ({0}), received bytes={1}", this.TcpEndpoint, bytesTransferred);
                    this.Disconnect();
                }
            }
            catch (Exception exception)
            {
                log.ErrorFormat("{0} RecvCallback:{1}", this.TcpEndpoint, exception);
                this.Disconnect();
            }
        }

        public virtual void resetKey()
        {
            this.RECEIVE_KEY = StreamProcessor.cloneArrary(StreamProcessor.KEY, 8);
            this.SEND_KEY = StreamProcessor.cloneArrary(StreamProcessor.KEY, 8);
        }

        public bool SendAsync(SocketAsyncEventArgs e)
        {
            int tickCount = Environment.TickCount;
            bool flag = true;
            if (this.m_sock.Connected)
            {
                flag = this.m_sock.SendAsync(e);
            }
            int num2 = Environment.TickCount - tickCount;
            if (num2 > 0x5dc)
            {
                log.WarnFormat("AsyncTcpSendCallback.BeginSend took {0}ms! (TCP to client: {1})", num2, this.TcpEndpoint);
            }
            return flag;
        }

        public virtual void SendTCP(GSPacketIn pkg)
        {
            this.m_processor.SendTCP(pkg);
        }

        public void SetFsm(int adder, int muliter)
        {
            this.m_processor.SetFsm(adder, muliter);
        }

        public virtual void setKey(byte[] data)
        {
            for (int i = 0; i < 8; i++)
            {
                this.RECEIVE_KEY[i] = data[i];
                this.SEND_KEY[i] = data[i];
            }
        }

        public bool AsyncPostSend
        {
            get
            {
                return this.m_asyncPostSend;
            }
            set
            {
                this.m_asyncPostSend = value;
            }
        }

        public bool Encryted
        {
            get
            {
                return this.m_encryted;
            }
            set
            {
                this.m_encryted = value;
            }
        }

        public bool IsConnected
        {
            get
            {
                return (this.m_isConnected == 1);
            }
        }

        public byte[] PacketBuf
        {
            get
            {
                return this.m_readBuffer;
            }
        }

        public int PacketBufSize
        {
            get
            {
                return this.m_readBufEnd;
            }
            set
            {
                this.m_readBufEnd = value;
            }
        }

        public byte[] SendBuffer
        {
            get
            {
                return this.m_sendBuffer;
            }
        }

        public System.Net.Sockets.Socket Socket
        {
            get
            {
                return this.m_sock;
            }
            set
            {
                this.m_sock = value;
            }
        }

        public bool Strict
        {
            get
            {
                return this.m_strict;
            }
            set
            {
                this.m_strict = value;
            }
        }

        public string TcpEndpoint
        {
            get
            {
                System.Net.Sockets.Socket sock = this.m_sock;
                if (((sock != null) && sock.Connected) && (sock.RemoteEndPoint != null))
                {
                    return sock.RemoteEndPoint.ToString();
                }
                return "not connected";
            }
        }
    }
}
