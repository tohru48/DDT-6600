namespace Game.Base
{
    using System;
    using System.IO;
    using System.Text;
    using System.Xml;
    using zlib;

    public class Marshal
    {
        public Marshal()
        {
        }

        public static byte[] Compress(byte[] src)
        {
            return Compress(src, 0, src.Length);
        }

        public static byte[] Compress(byte[] src, int offset, int length)
        {
            MemoryStream stream = new MemoryStream();
            Stream stream2 = new ZOutputStream(stream, 9);
            stream2.Write(src, offset, length);
            stream2.Close();
            return stream.ToArray();
        }

        public static XmlDocument LoadXMLData(string filename, bool isEncrypt)
        {
            try
            {
                byte[] rawData = File.ReadAllBytes("xml/" + filename + ".xml");

                if (isEncrypt)
                    rawData = Uncompress(rawData);

                XmlDocument xDoc = new XmlDocument();

                xDoc.Load(new MemoryStream(rawData));

                return xDoc;
            }
            catch (Exception)
            {
                Console.WriteLine("File " + filename + "not found!");
            }

            return null;
        }
        public static XmlDocument smethod_0(string filename, bool isEncrypt)
        {
            XmlDocument xmlDocument;
            try
            {
                byte[] numArray = File.ReadAllBytes(string.Concat("xml/", filename, ".xml"));
                if (isEncrypt)
                {
                    numArray = Marshal.Uncompress(numArray);
                }
                XmlDocument xmlDocument1 = new XmlDocument();
                xmlDocument1.Load(new MemoryStream(numArray));
                xmlDocument = xmlDocument1;
            }
            catch (Exception exception)
            {
                Console.WriteLine(string.Concat("File ", filename, "not found!"));
                return null;
            }
            return xmlDocument;
        }

        public static short ConvertToInt16(byte[] val)
        {
            return ConvertToInt16(val, 0);
        }

        public static short ConvertToInt16(byte v1, byte v2)
        {
            return (short)((v1 << 8) | v2);
        }

        public static short ConvertToInt16(byte[] val, int startIndex)
        {
            return ConvertToInt16(val[startIndex], val[startIndex + 1]);
        }

        public static int ConvertToInt32(byte[] val)
        {
            return ConvertToInt32(val, 0);
        }

        public static int ConvertToInt32(byte[] val, int startIndex)
        {
            return ConvertToInt32(val[startIndex], val[startIndex + 1], val[startIndex + 2], val[startIndex + 3]);
        }

        public static int ConvertToInt32(byte v1, byte v2, byte v3, byte v4)
        {
            return ((((v1 << 0x18) | (v2 << 0x10)) | (v3 << 8)) | v4);
        }

        public static long ConvertToInt64(int v1, uint v2)
        {
            int num = 1;
            if (v1 < 0)
            {
                num = -1;
            }
            return (long)(num * (Math.Abs((double)(v1 * Math.Pow(2.0, 32.0))) + v2));
        }

        public static string ConvertToString(byte[] cstyle)
        {
            if (cstyle == null)
            {
                return null;
            }
            for (int i = 0; i < cstyle.Length; i++)
            {
                if (cstyle[i] == 0)
                {
                    return Encoding.Default.GetString(cstyle, 0, i);
                }
            }
            return Encoding.Default.GetString(cstyle);
        }

        public static ushort ConvertToUInt16(byte[] val)
        {
            return ConvertToUInt16(val, 0);
        }

        public static ushort ConvertToUInt16(byte v1, byte v2)
        {
            return (ushort)(v2 | (v1 << 8));
        }

        public static ushort ConvertToUInt16(byte[] val, int startIndex)
        {
            return ConvertToUInt16(val[startIndex], val[startIndex + 1]);
        }

        public static uint ConvertToUInt32(byte[] val)
        {
            return ConvertToUInt32(val, 0);
        }

        public static uint ConvertToUInt32(byte[] val, int startIndex)
        {
            return ConvertToUInt32(val[startIndex], val[startIndex + 1], val[startIndex + 2], val[startIndex + 3]);
        }

        public static uint ConvertToUInt32(byte v1, byte v2, byte v3, byte v4)
        {
            return (uint)((((v1 << 0x18) | (v2 << 0x10)) | (v3 << 8)) | v4);
        }

        public static string ToHexDump(string description, byte[] dump)
        {
            return ToHexDump(description, dump, 0, dump.Length);
        }

        public static string ToHexDump(string description, byte[] dump, int start, int count)
        {
            StringBuilder builder = new StringBuilder();
            if (description != null)
            {
                builder.Append(description).Append("\n");
            }
            int num = start + count;
            for (int i = start; i < num; i += 0x10)
            {
                StringBuilder builder2 = new StringBuilder();
                StringBuilder builder3 = new StringBuilder();
                builder3.Append(i.ToString("X4"));
                builder3.Append(": ");
                for (int j = 0; j < 0x10; j++)
                {
                    if ((j + i) < num)
                    {
                        byte num4 = dump[j + i];
                        builder3.Append(dump[j + i].ToString("X2"));
                        builder3.Append(" ");
                        if ((num4 >= 0x20) && (num4 <= 0x7f))
                        {
                            builder2.Append((char)num4);
                        }
                        else
                        {
                            builder2.Append(".");
                        }
                    }
                    else
                    {
                        builder3.Append("   ");
                        builder2.Append(" ");
                    }
                }
                builder3.Append("  ");
                builder3.Append(builder2.ToString());
                builder3.Append('\n');
                builder.Append(builder3.ToString());
            }
            return builder.ToString();
        }

        public static byte[] Uncompress(byte[] src)
        {
            MemoryStream stream = new MemoryStream();
            Stream stream2 = new ZOutputStream(stream);
            stream2.Write(src, 0, src.Length);
            stream2.Close();
            return stream.ToArray();
        }
    }
}
