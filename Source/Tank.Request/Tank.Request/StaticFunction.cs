using System.Configuration;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Road.Flash;
using zlib;

namespace Tank.Request
{
	public class StaticFunction
	{
		public static RSACryptoServiceProvider RsaCryptor
		{
			get
			{
				string privateKey = ConfigurationManager.AppSettings["privateKey"];
				return CryptoHelper.GetRSACrypto(privateKey);
			}
		}

		public static byte[] Compress(string str)
		{
			byte[] bytes = Encoding.UTF8.GetBytes(str);
			return Compress(bytes);
		}

		public static byte[] Compress(byte[] src)
		{
			return Compress(src, 0, src.Length);
		}

		public static byte[] Compress(byte[] src, int offset, int length)
		{
			MemoryStream memoryStream = new MemoryStream();
			Stream stream = new ZOutputStream(memoryStream, 9);
			stream.Write(src, offset, length);
			stream.Close();
			return memoryStream.ToArray();
		}

		public static string Uncompress(string str)
		{
			byte[] bytes = Encoding.UTF8.GetBytes(str);
			return Encoding.UTF8.GetString(Uncompress(bytes));
		}

		public static byte[] Uncompress(byte[] src)
		{
			MemoryStream memoryStream = new MemoryStream();
			Stream stream = new ZOutputStream(memoryStream);
			stream.Write(src, 0, src.Length);
			stream.Close();
			return memoryStream.ToArray();
		}
	}
}
