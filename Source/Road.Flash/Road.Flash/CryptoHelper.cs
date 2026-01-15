using System;
using System.Security.Cryptography;
using System.Text;

namespace Road.Flash
{
	public class CryptoHelper
	{
		public static RSACryptoServiceProvider GetRSACrypto(string privateKey)
		{
			CspParameters cspParameters = new CspParameters();
			cspParameters.Flags = CspProviderFlags.UseMachineKeyStore;
			RSACryptoServiceProvider rSACryptoServiceProvider = new RSACryptoServiceProvider(cspParameters);
			rSACryptoServiceProvider.FromXmlString(privateKey);
			return rSACryptoServiceProvider;
		}

		public static string RsaDecrypt(string privateKey, string src)
		{
			CspParameters cspParameters = new CspParameters();
			cspParameters.Flags = CspProviderFlags.UseMachineKeyStore;
			RSACryptoServiceProvider rSACryptoServiceProvider = new RSACryptoServiceProvider(cspParameters);
			rSACryptoServiceProvider.FromXmlString(privateKey);
			return RsaDecrypt(rSACryptoServiceProvider, src);
		}

		public static string RsaDecrypt(RSACryptoServiceProvider rsa, string src)
		{
			byte[] rgb = Convert.FromBase64String(src);
			byte[] bytes = rsa.Decrypt(rgb, fOAEP: false);
			return Encoding.UTF8.GetString(bytes);
		}

		public static byte[] StringToByteArray(string hex)
		{
			int length = hex.Length;
			byte[] array = new byte[length / 2];
			for (int i = 0; i < length; i += 2)
			{
				array[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
			}
			return array;
		}

		public static string ByteArrayToString(byte[] ba)
		{
			StringBuilder stringBuilder = new StringBuilder(ba.Length * 2);
			for (int i = 0; i < ba.Length; i++)
			{
				stringBuilder.Append(ba[i].ToString("X2"));
			}
			return stringBuilder.ToString();
		}

		public static byte[] RsaDecryt2(RSACryptoServiceProvider rsa, string src)
		{
			byte[] rgb = Convert.FromBase64String(src);
			return rsa.Decrypt(rgb, fOAEP: false);
		}

		public static byte[] RsaDecryt3(RSACryptoServiceProvider rsa, string src)
		{
			byte[] rgb = Convert.FromBase64String(src);
			return rsa.Decrypt(rgb, fOAEP: false);
		}

		public static string TripleDesDecrypt(string privateKey, string iv, string cypherText)
		{
			byte[] key = StringToByteArray(privateKey);
			byte[] array = StringToByteArray(cypherText);
			TripleDESCryptoServiceProvider tripleDESCryptoServiceProvider = new TripleDESCryptoServiceProvider();
			tripleDESCryptoServiceProvider.Key = key;
			tripleDESCryptoServiceProvider.Mode = CipherMode.CBC;
			tripleDESCryptoServiceProvider.Padding = PaddingMode.Zeros;
			tripleDESCryptoServiceProvider.IV = StringToByteArray(iv);
			TripleDESCryptoServiceProvider tripleDESCryptoServiceProvider2 = tripleDESCryptoServiceProvider;
			TripleDESCryptoServiceProvider tripleDESCryptoServiceProvider3 = tripleDESCryptoServiceProvider2;
			byte[] bytes = tripleDESCryptoServiceProvider3.CreateDecryptor().TransformFinalBlock(array, 0, array.Length);
			return Encoding.UTF8.GetString(bytes).Replace('\0', ' ').Trim();
		}

		public static string TripleDesEncrypt(string privateKey, string plainText, ref string iv)
		{
			byte[] bytes = default(byte[]);
			TripleDESCryptoServiceProvider tripleDESCryptoServiceProvider3 = default(TripleDESCryptoServiceProvider);
            byte[] key = StringToByteArray(privateKey);
            bytes = Encoding.UTF8.GetBytes(plainText);
            TripleDESCryptoServiceProvider tripleDESCryptoServiceProvider = new TripleDESCryptoServiceProvider();
            tripleDESCryptoServiceProvider.Key = key;
            tripleDESCryptoServiceProvider.Mode = CipherMode.CBC;
            tripleDESCryptoServiceProvider.Padding = PaddingMode.Zeros;
            TripleDESCryptoServiceProvider tripleDESCryptoServiceProvider2 = tripleDESCryptoServiceProvider;
            tripleDESCryptoServiceProvider3 = tripleDESCryptoServiceProvider2;
            if (iv == null)
            {
                goto IL_0067;
            }
            if (iv.Length == 16)
			{
				tripleDESCryptoServiceProvider3.IV = StringToByteArray(iv);
			}
			goto IL_0067;
			IL_0067:
			string result = ByteArrayToString(tripleDESCryptoServiceProvider3.CreateEncryptor().TransformFinalBlock(bytes, 0, bytes.Length));
			if (iv != null)
			{
				iv = ByteArrayToString(tripleDESCryptoServiceProvider3.IV);
			}
			return result;
		}

		static CryptoHelper()
		{
		}
	}
}
