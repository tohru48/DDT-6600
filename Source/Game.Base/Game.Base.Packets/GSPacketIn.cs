namespace Game.Base.Packets
{
    using Game.Base;
    using log4net;
    using System;
    using System.Reflection;

    public class GSPacketIn : PacketIn
    {
        public const ushort HDR_SIZE = 20;
        public const short HEADER = 0x71ab;
        private static readonly ILog log;
        protected int m_cliendId;
        protected short m_code;
        protected int m_parameter1;
        protected int m_parameter2;

        static GSPacketIn()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        public GSPacketIn(short code)
            : this(code, 0, 0x2000)
        {
        }

        public GSPacketIn(byte[] buf, int size)
            : base(buf, size)
        {
        }

        public GSPacketIn(short code, int clientId)
            : this(code, clientId, 0x2000)
        {
        }

        public GSPacketIn(short code, int clientId, int size)
            : base(new byte[size], 20)
        {
            this.m_code = code;
            this.m_cliendId = clientId;
            base.m_offset = 20;
        }

        public short checkSum()
        {
            short num = 0x77;
            int num2 = 6;
            while (num2 < base.m_length)
            {
                try
                {
                    num = (short)(num + base.m_buffer[num2++]);
                    continue;
                }
                catch
                {
                    continue;
                }
            }
            return (short)(num & 0x7f7f);
        }

        public void ClearContext()
        {
            base.m_offset = 20;
            base.m_length = 20;
        }

        public GSPacketIn Clone()
        {
            GSPacketIn @in = new GSPacketIn(base.m_buffer, base.m_length);
            @in.ReadHeader();
            @in.Offset = base.m_length;
            return @in;
        }

        public void Compress()
        {
            byte[] src = Marshal.Compress(base.m_buffer, 20, base.Length - 20);
            base.m_offset = 20;
            this.Write(src);
            base.m_length = src.Length + 20;
        }

        public void ReadHeader()
        {
            this.ReadShort();
            base.m_length = this.ReadShort();
            this.ReadShort();
            this.m_code = this.ReadShort();
            this.m_cliendId = this.ReadInt();
            this.m_parameter1 = this.ReadInt();
            this.m_parameter2 = this.ReadInt();
        }

        public GSPacketIn ReadPacket()
        {
            byte[] buf = this.ReadBytes();
            GSPacketIn @in = new GSPacketIn(buf, buf.Length);
            @in.ReadHeader();
            return @in;
        }

        public void UnCompress()
        {
        }

        public void WriteHeader()
        {
            lock (this)
            {
                int offset = base.m_offset;
                base.m_offset = 0;
                base.WriteShort(0x71ab);
                base.WriteShort((short)base.m_length);
                base.WriteShort(this.checkSum());
                base.WriteShort(this.m_code);
                base.WriteInt(this.m_cliendId);
                base.WriteInt(this.m_parameter1);
                base.WriteInt(this.m_parameter2);
                base.m_offset = offset;
            }
            lock (this)
            {
                int num2 = base.m_offset;
                base.m_offset = 0;
                base.WriteShort(0x71ab);
                base.WriteShort((short)base.m_length);
                base.WriteShort(this.checkSum());
                base.WriteShort(this.m_code);
                base.WriteInt(this.m_cliendId);
                base.WriteInt(this.m_parameter1);
                base.WriteInt(this.m_parameter2);
                base.m_offset = num2;
            }
        }
        public void ClearOffset()
        {
            m_offset = HDR_SIZE;
        }

        public void WriteHeader3()
        {
            lock (this)
            {
                int offset = base.m_offset;
                base.m_offset = 0;
                this.WriteShort(0x71ab);
                this.WriteShort((short)base.m_length);
                base.m_offset = 6;
                this.WriteShort(this.m_code);
                this.WriteInt(this.m_cliendId);
                this.WriteInt(this.m_parameter1);
                this.WriteInt(this.m_parameter2);
                base.m_offset = 4;
                this.WriteShort(this.checkSum());
                base.m_offset = offset;
            }
        }

        public void WritePacket(GSPacketIn pkg)
        {
            pkg.WriteHeader();
            this.Write(pkg.Buffer, 0, pkg.Length);
        }

        public int ClientID
        {
            get
            {
                return this.m_cliendId;
            }
            set
            {
                this.m_cliendId = value;
            }
        }

        public short Code
        {
            get
            {
                return this.m_code;
            }
            set
            {
                this.m_code = value;
            }
        }

        public int Parameter1
        {
            get
            {
                return this.m_parameter1;
            }
            set
            {
                this.m_parameter1 = value;
            }
        }

        public int Parameter2
        {
            get
            {
                return this.m_parameter2;
            }
            set
            {
                this.m_parameter2 = value;
            }
        }
    }
}

