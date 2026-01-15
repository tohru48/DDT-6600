namespace Game.Base.Packets
{
    using Game.Base;
    using log4net;
    using Road.Base.Packets;
    using System;
    using System.Collections;
    using System.Net.Sockets;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using System.Text;
    using System.Threading;

    public class StreamProcessor
    {
        public static byte[] KEY;
        private static readonly ILog log;
        protected readonly BaseClient m_client;
        protected int m_firstPkgOffset;
        protected int m_sendBufferLength;
        protected bool m_sendingTcp;
        protected Queue m_tcpQueue;
        protected byte[] m_tcpSendBuffer;
        private FSM receive_fsm;
        private SocketAsyncEventArgs send_event;
        private FSM send_fsm;

        static StreamProcessor()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            KEY = new byte[] { 0xae, 0xbf, 0x56, 120, 0xab, 0xcd, 0xef, 0xf1 };
        }

        public StreamProcessor(BaseClient client)
        {
            this.m_client = client;
            this.m_client.resetKey();
            this.m_tcpSendBuffer = client.SendBuffer;
            this.m_tcpQueue = new Queue(0x100);
            this.send_event = new SocketAsyncEventArgs();
            this.send_event.UserToken = this;
            this.send_event.Completed += new EventHandler<SocketAsyncEventArgs>(StreamProcessor.AsyncTcpSendCallback);
            this.send_event.SetBuffer(this.m_tcpSendBuffer, 0, 0);
            this.send_fsm = new FSM(0x7abcdef7, 0x5dd, "send_fsm");
            this.receive_fsm = new FSM(0x7abcdef7, 0x5dd, "receive_fsm");
        }

        private static void AsyncSendTcpImp(object state)
        {
            StreamProcessor sender = state as StreamProcessor;
            BaseClient client = sender.m_client;
            try
            {
                AsyncTcpSendCallback(sender, sender.send_event);
            }
            catch (Exception exception)
            {
                log.Error("AsyncSendTcpImp", exception);
                client.Disconnect();
            }
        }

        private static void AsyncTcpSendCallback(object sender, SocketAsyncEventArgs e)
        {
            StreamProcessor userToken = (StreamProcessor)e.UserToken;
            BaseClient client = userToken.m_client;
            try
            {
                Queue tcpQueue = userToken.m_tcpQueue;
                if ((tcpQueue != null) && client.Socket.Connected)
                {
                    int bytesTransferred = e.BytesTransferred;
                    byte[] tcpSendBuffer = userToken.m_tcpSendBuffer;
                    int length = 0;
                    if ((bytesTransferred != e.Count) && (userToken.m_sendBufferLength > bytesTransferred))
                    {
                        length = userToken.m_sendBufferLength - bytesTransferred;
                        Array.Copy(tcpSendBuffer, bytesTransferred, tcpSendBuffer, 0, length);
                    }
                    e.SetBuffer(0, 0);
                    int firstPkgOffset = userToken.m_firstPkgOffset;
                    lock (tcpQueue.SyncRoot)
                    {
                        PacketIn @in;
                        int num5;
                        int num4 = 0;
                        if (tcpQueue.Count <= 0)
                        {
                            goto Label_015B;
                        }
                        goto Label_0134;
                    Label_009D:
                        num5 = @in.CopyTo(tcpSendBuffer, length, firstPkgOffset);
                    Label_00AC:
                        if (num5 == 0)
                        {
                            num4++;
                        }
                        else
                        {
                            num4 = 0;
                        }
                        firstPkgOffset += num5;
                        length += num5;
                        if (@in.Length <= firstPkgOffset)
                        {
                            tcpQueue.Dequeue();
                            firstPkgOffset = 0;
                            if (client.Encryted)
                            {
                                userToken.send_fsm.UpdateState();
                                @in.isSended = true;
                            }
                        }
                        if (tcpSendBuffer.Length != length)
                        {
                            if (num4 > 5)
                            {
                                goto Label_0151;
                            }
                            if (tcpQueue.Count > 0)
                            {
                                goto Label_0134;
                            }
                        }
                        goto Label_015B;
                    Label_0114:
                        num5 = @in.CopyTo3(tcpSendBuffer, length, firstPkgOffset, client.SEND_KEY, ref client.numPacketProcces);
                        goto Label_00AC;
                    Label_0134:
                        @in = (PacketIn)tcpQueue.Peek();
                        num5 = 0;
                        if (!client.Encryted)
                        {
                            goto Label_009D;
                        }
                        goto Label_0114;
                    Label_0151:
                        @in.isSended = true;
                    Label_015B:
                        userToken.m_firstPkgOffset = firstPkgOffset;
                        if (length <= 0)
                        {
                            userToken.m_sendingTcp = false;
                            return;
                        }
                    }
                    userToken.m_sendBufferLength = length;
                    e.SetBuffer(0, length);
                    if (!client.SendAsync(e))
                    {
                        AsyncTcpSendCallback(sender, e);
                    }
                }
            }
            catch (Exception exception)
            {
                log.Error("AsyncTcpSendCallback", exception);
                log.WarnFormat("It seems <{0}> went linkdead. Closing connection. (SendTCP, {1}: {2})", client, exception.GetType(), exception.Message);
                client.Disconnect();
            }
        }

        public static byte[] cloneArrary(byte[] arr, int length = 8)
        {
            byte[] buffer = new byte[length];
            for (int i = 0; i < length; i++)
            {
                buffer[i] = arr[i];
            }
            return buffer;
        }

        public static byte[] decryptBytes(byte[] param1, int curOffset, int param2, byte[] param3)
        {
            byte[] buffer = new byte[param2];
            for (int i = 0; i < param2; i++)
            {
                buffer[i] = param1[i];
            }
            for (int j = 0; j < param2; j++)
            {
                if (j > 0)
                {
                    param3[j % 8] = (byte)((param3[j % 8] + param1[(curOffset + j) - 1]) ^ j);
                    buffer[j] = (byte)((param1[curOffset + j] - param1[(curOffset + j) - 1]) ^ param3[j % 8]);
                }
                else
                {
                    buffer[0] = (byte)(param1[curOffset] ^ param3[0]);
                }
            }
            return buffer;
        }

        public void Dispose()
        {
            this.send_event.Dispose();
            this.m_tcpQueue.Clear();
        }

        public static string PrintArray(byte[] arr, int length = 8)
        {
            StringBuilder builder = new StringBuilder();
            builder.Append("[");
            for (int i = 0; i < length; i++)
            {
                builder.AppendFormat("{0} ", arr[i]);
            }
            builder.Append("]");
            return builder.ToString();
        }

        public static string PrintArray(byte[] arr, int first, int length)
        {
            StringBuilder builder = new StringBuilder();
            builder.Append("[");
            for (int i = first; i < (first + length); i++)
            {
                builder.AppendFormat("{0} ", arr[i]);
            }
            builder.Append("]");
            return builder.ToString();
        }

        public void ReceiveBytes(int numBytes)
        {
            lock (this)
            {
                int num3;
                byte[] buffer2;
                byte[] buffer3;
                byte[] packetBuf = this.m_client.PacketBuf;
                int num = this.m_client.PacketBufSize + numBytes;
                if (num < 20)
                {
                    this.m_client.PacketBufSize = num;
                    goto Label_0200;
                }
                this.m_client.PacketBufSize = 0;
                int index = 0;
            Label_0047:
                num3 = 0;
                int num4 = 0;
                if (!this.m_client.Encryted)
                {
                    goto Label_007A;
                }
                goto Label_0138;
            Label_005E:
                num4 = (packetBuf[index] << 8) + packetBuf[index + 1];
                if (num4 == 0x71ab)
                {
                    goto Label_0082;
                }
                index++;
            Label_007A:
                if ((index + 4) < num)
                {
                    goto Label_005E;
                }
                goto Label_0090;
            Label_0082:
                num3 = (packetBuf[index + 2] << 8) + packetBuf[index + 3];
            Label_0090:
                if (((num3 != 0) && (num3 < 20)) || (num3 > 0x2000))
                {
                    goto Label_01A0;
                }
                int length = num - index;
                if ((length < num3) || (num3 == 0))
                {
                    goto Label_01C6;
                }
                GSPacketIn pkg = new GSPacketIn(new byte[0x2000], 0x2000);
                if (this.m_client.Encryted)
                {
                    pkg.CopyFrom3(packetBuf, index, 0, num3, this.m_client.RECEIVE_KEY);
                }
                else
                {
                    pkg.CopyFrom(packetBuf, index, 0, num3);
                }
                pkg.ReadHeader();
                try
                {
                    this.m_client.OnRecvPacket(pkg);
                }
                catch (Exception exception)
                {
                    if (log.IsErrorEnabled)
                    {
                        log.Error("HandlePacket(pak)", exception);
                    }
                }
                goto Label_0191;
            Label_0138:
                buffer2 = cloneArrary(this.m_client.RECEIVE_KEY, 8);
                while ((index + 4) < num)
                {
                    buffer3 = decryptBytes(packetBuf, index, 8, buffer2);
                    num4 = (buffer3[0] << 8) + buffer3[1];
                    if (num4 == 0x71ab)
                    {
                        goto Label_0180;
                    }
                    index++;
                }
                goto Label_0090;
            Label_0180:
                num3 = (buffer3[2] << 8) + buffer3[3];
                goto Label_0090;
            Label_0191:
                index += num3;
                if ((num - 1) > index)
                {
                    goto Label_0047;
                }
                goto Label_01DE;
            Label_01A0:
                this.m_client.PacketBufSize = 0;
                if (this.m_client.Strict)
                {
                    this.m_client.Disconnect();
                }
                goto Label_0200;
            Label_01C6:
                Array.Copy(packetBuf, index, packetBuf, 0, length);
                this.m_client.PacketBufSize = length;
            Label_01DE:
                if ((num - 1) == index)
                {
                    packetBuf[0] = packetBuf[index];
                    this.m_client.PacketBufSize = 1;
                }
            Label_0200: ;
            }
        }

        public void SendTCP(GSPacketIn packet)
        {
            packet.WriteHeader();
            packet.Offset = 0;
            if (this.m_client.Socket.Connected)
            {
                try
                {
                    Statistics.BytesOut += packet.Length;
                    Statistics.PacketsOut += 1L;
                    lock (this.m_tcpQueue.SyncRoot)
                    {
                        this.m_tcpQueue.Enqueue(packet);
                        if (this.m_sendingTcp)
                        {
                            return;
                        }
                        this.m_sendingTcp = true;
                    }
                    if (this.m_client.AsyncPostSend)
                    {
                        ThreadPool.QueueUserWorkItem(new WaitCallback(StreamProcessor.AsyncSendTcpImp), this);
                    }
                    else
                    {
                        AsyncTcpSendCallback(this, this.send_event);
                    }
                }
                catch (Exception exception)
                {
                    log.Error("SendTCP", exception);
                    log.WarnFormat("It seems <{0}> went linkdead. Closing connection. (SendTCP, {1}: {2})", this.m_client, exception.GetType(), exception.Message);
                    this.m_client.Disconnect();
                }
            }
        }

        public void SetFsm(int adder, int muliter)
        {
            this.send_fsm.Setup(adder, muliter);
            this.receive_fsm.Setup(adder, muliter);
        }
    }
}

