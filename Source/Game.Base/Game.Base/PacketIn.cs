namespace Game.Base
{
    using System;
    using System.Runtime.CompilerServices;
    using System.Text;
    using System.Threading;

    public class PacketIn
    {
        public volatile bool isSended;
        private byte lastbits;
        protected byte[] m_buffer;
        protected byte[] m_buffer2;
        protected int m_length;
        public volatile int m_loop;
        protected int m_offset;
        public volatile int m_sended;
        public volatile int packetNum;

        public PacketIn(byte[] buf, int len)
        {
            this.isSended = true;
            this.m_buffer = buf;
            this.m_length = len;
            this.m_offset = 0;
        }

        public virtual int CopyFrom(byte[] src, int srcOffset, int offset, int count)
        {
            if ((count < this.m_buffer.Length) && ((count - srcOffset) < src.Length))
            {
                System.Buffer.BlockCopy(src, srcOffset, this.m_buffer, offset, count);
                return count;
            }
            return -1;
        }

        public virtual int CopyFrom(byte[] src, int srcOffset, int offset, int count, int key)
        {
            if ((count >= this.m_buffer.Length) || ((count - srcOffset) >= src.Length))
            {
                return -1;
            }
            key = (key & 0xff0000) >> 0x10;
            for (int i = 0; i < count; i++)
            {
                this.m_buffer[offset + i] = (byte)(src[srcOffset + i] ^ key);
            }
            return count;
        }

        public virtual int[] CopyFrom3(byte[] src, int srcOffset, int offset, int count, byte[] key)
        {
            int[] numArray = new int[count];
            for (int i = 0; i < count; i++)
            {
                this.m_buffer[i] = src[i];
            }
            if ((count < this.m_buffer.Length) && ((count - srcOffset) < src.Length))
            {
                this.m_buffer[0] = (byte)(src[srcOffset] ^ key[0]);
                for (int j = 1; j < count; j++)
                {
                    key[j % 8] = (byte)((key[j % 8] + src[(srcOffset + j) - 1]) ^ j);
                    this.m_buffer[j] = (byte)((src[srcOffset + j] - src[(srcOffset + j) - 1]) ^ key[j % 8]);
                }
            }
            return numArray;
        }

        public virtual int CopyTo(byte[] dst, int dstOffset, int offset)
        {
            int count = ((this.m_length - offset) < (dst.Length - dstOffset)) ? (this.m_length - offset) : (dst.Length - dstOffset);
            if (count > 0)
            {
                System.Buffer.BlockCopy(this.m_buffer, offset, dst, dstOffset, count);
            }
            return count;
        }

        public virtual int CopyTo(byte[] dst, int dstOffset, int offset, byte[] key)
        {
            int num = ((this.m_length - offset) < (dst.Length - dstOffset)) ? (this.m_length - offset) : (dst.Length - dstOffset);
            if (num > 0)
            {
                for (int i = 0; i < num; i++)
                {
                    if ((offset + i) == 0)
                    {
                        dst[dstOffset] = (byte)(this.m_buffer[offset + i] ^ key[(offset + i) % 8]);
                    }
                    else if ((i == 0) && (dstOffset == 0))
                    {
                        key[(offset + i) % 8] = (byte)((key[(offset + i) % 8] + this.lastbits) ^ (offset + i));
                        dst[dstOffset + i] = (byte)((this.m_buffer[offset + i] ^ key[(offset + i) % 8]) + this.lastbits);
                    }
                    else
                    {
                        key[(offset + i) % 8] = (byte)((key[(offset + i) % 8] + dst[(dstOffset + i) - 1]) ^ (offset + i));
                        dst[dstOffset + i] = (byte)((this.m_buffer[offset + i] ^ key[(offset + i) % 8]) + dst[(dstOffset + i) - 1]);
                        if (i == (num - 1))
                        {
                            this.lastbits = dst[dstOffset + i];
                        }
                    }
                }
            }
            return num;
        }

        public virtual int CopyTo3(byte[] dst, int dstOffset, int offset, byte[] key, ref int packetArrangeSend)
        {
            int num = ((this.m_length - offset) < (dst.Length - dstOffset)) ? (this.m_length - offset) : (dst.Length - dstOffset);
            lock (this)
            {
                if (num > 0)
                {
                    int num2;
                    if (this.isSended)
                    {
                        this.packetNum = Interlocked.Increment(ref packetArrangeSend);
                        packetArrangeSend = this.packetNum;
                        this.m_sended = 0;
                        this.isSended = false;
                        num2 = this.m_sended + dstOffset;
                    }
                    else
                    {
                        num2 = 0x2000;
                    }
                    if (this.packetNum != packetArrangeSend)
                    {
                        return 0;
                    }
                    for (int i = 0; i < num; i++)
                    {
                        int index = offset + i;
                        while (num2 > 0x2000)
                        {
                            num2 -= 0x2000;
                        }
                        if (this.m_sended == 0)
                        {
                            dst[dstOffset] = (byte)(this.m_buffer[index] ^ key[this.m_sended % 8]);
                        }
                        else
                        {
                            if (num2 == 0)
                            {
                                return 0;
                            }
                            key[this.m_sended % 8] = (byte)((key[this.m_sended % 8] + dst[num2 - 1]) ^ this.m_sended);
                            dst[dstOffset + i] = (byte)((this.m_buffer[index] ^ key[this.m_sended % 8]) + dst[num2 - 1]);
                        }
                        this.m_sended++;
                        num2++;
                    }
                }
                return num;
            }
            return num;
        }

        public virtual void Fill(byte val, int num)
        {
            for (int i = 0; i < num; i++)
            {
                this.WriteByte(val);
            }
        }

        public virtual bool ReadBoolean()
        {
            return (this.m_buffer[this.m_offset++] != 0);
        }

        public virtual byte ReadByte()
        {
            return this.m_buffer[this.m_offset++];
        }

        public virtual byte[] ReadBytes()
        {
            return this.ReadBytes(this.m_length - this.m_offset);
        }

        public virtual byte[] ReadBytes(int maxLen)
        {
            byte[] destinationArray = new byte[maxLen];
            Array.Copy(this.m_buffer, this.m_offset, destinationArray, 0, maxLen);
            this.m_offset += maxLen;
            return destinationArray;
        }

        public DateTime ReadDateTime()
        {
            return new DateTime(this.ReadShort(), this.ReadByte(), this.ReadByte(), this.ReadByte(), this.ReadByte(), this.ReadByte());
        }

        public virtual double ReadDouble()
        {
            byte[] buffer = new byte[8];
            for (int i = 0; i < buffer.Length; i++)
            {
                buffer[i] = this.ReadByte();
            }
            return BitConverter.ToDouble(buffer, 0);
        }

        public virtual float ReadFloat()
        {
            byte[] buffer = new byte[4];
            for (int i = 0; i < buffer.Length; i++)
            {
                buffer[i] = this.ReadByte();
            }
            return BitConverter.ToSingle(buffer, 0);
        }

        public virtual int ReadInt()
        {
            byte num = this.ReadByte();
            byte num2 = this.ReadByte();
            byte num3 = this.ReadByte();
            byte num4 = this.ReadByte();
            return Marshal.ConvertToInt32(num, num2, num3, num4);
        }

        public virtual long ReadLong()
        {
            int num = this.ReadInt();
            long num2 = this.readUnsignedInt();
            int num3 = 1;
            if (num < 0)
            {
                num3 = -1;
            }
            return (long)(num3 * (Math.Abs((double)(num * Math.Pow(2.0, 32.0))) + num2));
        }

        public virtual short ReadShort()
        {
            byte num = this.ReadByte();
            byte num2 = this.ReadByte();
            return Marshal.ConvertToInt16(num, num2);
        }

        public virtual short ReadShortLowEndian()
        {
            byte num = this.ReadByte();
            return Marshal.ConvertToInt16(this.ReadByte(), num);
        }

        public virtual string ReadString()
        {
            short num = this.ReadShort();
            string str = Encoding.UTF8.GetString(this.m_buffer, this.m_offset, (int)num);
            this.m_offset += (int)num;
            return str.Replace("\0", "");
        }
        public virtual uint ReadUInt()
        {
            byte num = this.ReadByte();
            byte num2 = this.ReadByte();
            byte num3 = this.ReadByte();
            byte num4 = this.ReadByte();
            return Marshal.ConvertToUInt32(num, num2, num3, num4);
        }

        public virtual long readUnsignedInt()
        {
            return (this.ReadInt() & ((long)0xffffffffL));
        }

        public void Skip(int num)
        {
            this.m_offset += num;
        }

        public virtual void vmethod_0(uint val)
        {
            this.WriteByte((byte)(val >> 0x18));
            this.WriteByte((byte)((val >> 0x10) & 0xff));
            this.WriteByte((byte)((val & 0xffff) >> 8));
            this.WriteByte((byte)((val & 0xffff) & 0xff));
        }

        public virtual void Write(byte[] src)
        {
            this.Write(src, 0, src.Length);
        }

        public virtual void Write(byte[] src, int offset, int len)
        {
            if ((this.m_offset + len) >= this.m_buffer.Length)
            {
                byte[] sourceArray = this.m_buffer;
                this.m_buffer = new byte[this.m_buffer.Length * 2];
                Array.Copy(sourceArray, this.m_buffer, sourceArray.Length);
                this.Write(src, offset, len);
            }
            else
            {
                Array.Copy(src, offset, this.m_buffer, this.m_offset, len);
                this.m_offset += len;
                this.m_length = (this.m_offset > this.m_length) ? this.m_offset : this.m_length;
            }
        }

        public virtual void Write3(byte[] src, int offset, int len)
        {
            Array.Copy(src, offset, this.m_buffer, this.m_offset, len);
            this.m_offset += len;
            this.m_length = (this.m_offset > this.m_length) ? this.m_offset : this.m_length;
        }

        public virtual void WriteBoolean(bool val)
        {
            if (this.m_offset == this.m_buffer.Length)
            {
                byte[] sourceArray = this.m_buffer;
                this.m_buffer = new byte[this.m_buffer.Length * 2];
                Array.Copy(sourceArray, this.m_buffer, sourceArray.Length);
            }
            this.m_buffer[this.m_offset++] = val ? ((byte)1) : ((byte)0);
            this.m_length = (this.m_offset > this.m_length) ? this.m_offset : this.m_length;
        }

        public virtual void WriteByte(byte val)
        {
            if (this.m_offset == this.m_buffer.Length)
            {
                byte[] sourceArray = this.m_buffer;
                this.m_buffer = new byte[this.m_buffer.Length * 2];
                Array.Copy(sourceArray, this.m_buffer, sourceArray.Length);
            }
            this.m_buffer[this.m_offset++] = val;
            this.m_length = (this.m_offset > this.m_length) ? this.m_offset : this.m_length;
        }

        public void WriteDateTime(DateTime date)
        {
            this.WriteShort((short)date.Year);
            this.WriteByte((byte)date.Month);
            this.WriteByte((byte)date.Day);
            this.WriteByte((byte)date.Hour);
            this.WriteByte((byte)date.Minute);
            this.WriteByte((byte)date.Second);
        }

        public virtual void WriteDouble(double val)
        {
            byte[] bytes = BitConverter.GetBytes(val);
            this.Write(bytes);
        }

        public virtual void WriteFloat(float val)
        {
            byte[] bytes = BitConverter.GetBytes(val);
            this.Write(bytes);
        }

        public virtual void WriteInt(int val)
        {
            this.WriteByte((byte)(val >> 0x18));
            this.WriteByte((byte)((val >> 0x10) & 0xff));
            this.WriteByte((byte)((val & 0xffff) >> 8));
            this.WriteByte((byte)((val & 0xffff) & 0xff));
        }

        public virtual void WriteLong(long val)
        {
            long num = val;
            int num2 = (int)num;
            string str = Convert.ToString(num, 2);
            string str2 = (str.Length <= 0x20) ? "" : str.Substring(0, str.Length - 0x20);
            int num3 = 0;
            for (int i = 0; i < str2.Length; i++)
            {
                string str3 = str2.Substring(str2.Length - (i + 1));
                if (!(str3 == "0"))
                {
                    if (!(str3 == "1"))
                    {
                        break;
                    }
                    num3 += ((int)1) << i;
                }
            }
            this.WriteInt(num3);
            this.WriteInt(num2);
        }

        public virtual void WriteShort(short val)
        {
            this.WriteByte((byte)(val >> 8));
            this.WriteByte((byte)(val & 0xff));
        }

        public virtual void WriteShortLowEndian(short val)
        {
            this.WriteByte((byte)(val & 0xff));
            this.WriteByte((byte)(val >> 8));
        }

        public virtual void WriteString(string str)
        {
            if (!string.IsNullOrEmpty(str))
            {
                byte[] bytes = Encoding.UTF8.GetBytes(str);
                this.WriteShort((short)(bytes.Length + 1));
                this.Write(bytes, 0, bytes.Length);
                this.WriteByte(0);
            }
            else
            {
                this.WriteShort(1);
                this.WriteByte(0);
            }
        }

        public virtual void WriteString(string str, int maxlen)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(str);
            int len = (bytes.Length < maxlen) ? bytes.Length : maxlen;
            this.WriteShort((short)len);
            this.Write(bytes, 0, len);
        }

        public byte[] Buffer
        {
            get
            {
                return this.m_buffer;
            }
        }

        public int DataLeft
        {
            get
            {
                return (this.m_length - this.m_offset);
            }
        }

        public int Length
        {
            get
            {
                return this.m_length;
            }
        }

        public int Offset
        {
            get
            {
                return this.m_offset;
            }
            set
            {
                this.m_offset = value;
            }
        }
    }
}
