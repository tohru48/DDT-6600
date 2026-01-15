using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Tank.Request
{
	public class phpresponse : IHttpHandler
	{
		private string m_iv => ConfigurationManager.AppSettings["m_iv"];

		private string m_key => ConfigurationManager.AppSettings["m_key"];

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			string text = context.Request["phpkey"];
			try
			{
				if (string.IsNullOrEmpty(text))
				{
					context.Response.Write("phpkey");
					return;
				}
				string text2 = DecryptRJ256(m_key, m_iv, text);
				string[] array = text2.Split(';');
				if (array.Length < 3)
				{
					context.Response.Write(5);
					return;
				}
				string text3 = array[0];
				string text4 = array[1];
				string[] array2 = array[2].Split('|');
				if (string.IsNullOrEmpty(text3))
				{
					context.Response.Write(3);
					return;
				}
				if (string.IsNullOrEmpty(text4))
				{
					context.Response.Write(6);
					return;
				}
				if (array2.Length == 0)
				{
					context.Response.Write(5);
					return;
				}
				if (array2.Length > 50)
				{
					context.Response.Write(4);
					return;
				}
				string text5 = text3;
				if (text5 != null && (text5 == "senditembyusername" || text5 == "senditembyid" || text5 == "senditembynickname"))
				{
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						PlayerInfo playerInfo = null;
						text5 = text3;
						if (text5 != null)
						{
							switch (text5)
							{
							case "senditembynickname":
								playerInfo = playerBussiness.GetUserSingleByNickName(text4);
								break;
							case "senditembyid":
								playerInfo = playerBussiness.GetUserSingleByUserID(int.Parse(text4));
								break;
							case "senditembyusername":
								playerInfo = playerBussiness.GetUserSingleByUserName(text4);
								break;
							}
						}
						if (playerInfo == null)
						{
							text5 = text3;
							if (text5 != null)
							{
								if (!(text5 == "senditembyusername"))
								{
									if (text5 == "senditembynickname" || text5 == "senditembyid")
									{
										context.Response.Write(6);
									}
								}
								else
								{
									context.Response.Write(7);
								}
							}
						}
						else
						{
							int num = 0;
							List<ItemInfo> list = new List<ItemInfo>();
							string[] array3 = array2;
							for (int i = 0; i < array3.Length; i++)
							{
								string text6 = array3[i];
								string[] array4 = text6.Split(',');
								if (array4.Length < 8)
								{
									num++;
								}
								else
								{
									ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(int.Parse(array4[0]));
									if (itemTemplateInfo == null)
									{
										num++;
									}
									else
									{
										ItemInfo itemInfo = ItemInfo.CreateFromTemplate(itemTemplateInfo, 1, 102);
										itemInfo.Count = int.Parse(array4[1]);
										itemInfo.StrengthenLevel = int.Parse(array4[2]);
										itemInfo.AttackCompose = int.Parse(array4[3]);
										itemInfo.AgilityCompose = int.Parse(array4[4]);
										itemInfo.LuckCompose = int.Parse(array4[5]);
										itemInfo.DefendCompose = int.Parse(array4[6]);
										itemInfo.ValidDate = int.Parse(array4[7]);
										itemInfo.IsBinds = true;
										list.Add(itemInfo);
									}
								}
							}
							if (num > 0)
							{
								context.Response.Write(2);
							}
							else if (WorldEventMgr.SendItemsToMail(list, playerInfo.ID, playerInfo.NickName, "Thư từ hệ thống webshop"))
							{
								context.Response.Write(0);
							}
							else
							{
								context.Response.Write(1);
							}
						}
						return;
					}
				}
				context.Response.Write(3);
			}
			catch (Exception ex)
			{
				context.Response.Write(ex.Message);
			}
		}

		public static string DecryptRJ256(string prm_key, string prm_iv, string prm_text_to_decrypt)
		{
			RijndaelManaged rijndaelManaged = new RijndaelManaged();
			rijndaelManaged.Padding = PaddingMode.Zeros;
			rijndaelManaged.Mode = CipherMode.CBC;
			rijndaelManaged.KeySize = 256;
			rijndaelManaged.BlockSize = 256;
			RijndaelManaged rijndaelManaged2 = rijndaelManaged;
			byte[] bytes = Encoding.ASCII.GetBytes(prm_key);
			byte[] bytes2 = Encoding.ASCII.GetBytes(prm_iv);
			ICryptoTransform transform = rijndaelManaged2.CreateDecryptor(bytes, bytes2);
			byte[] array = Convert.FromBase64String(prm_text_to_decrypt);
			byte[] array2 = new byte[array.Length];
			MemoryStream stream = new MemoryStream(array);
			CryptoStream cryptoStream = new CryptoStream(stream, transform, CryptoStreamMode.Read);
			cryptoStream.Read(array2, 0, array2.Length);
			return Encoding.ASCII.GetString(array2);
		}

		public static string EncryptRJ256(string prm_key, string prm_iv, string prm_text_to_encrypt)
		{
			RijndaelManaged rijndaelManaged = new RijndaelManaged();
			rijndaelManaged.Padding = PaddingMode.Zeros;
			rijndaelManaged.Mode = CipherMode.CBC;
			rijndaelManaged.KeySize = 256;
			rijndaelManaged.BlockSize = 256;
			RijndaelManaged rijndaelManaged2 = rijndaelManaged;
			byte[] bytes = Encoding.ASCII.GetBytes(prm_key);
			byte[] bytes2 = Encoding.ASCII.GetBytes(prm_iv);
			ICryptoTransform transform = rijndaelManaged2.CreateEncryptor(bytes, bytes2);
			MemoryStream memoryStream = new MemoryStream();
			CryptoStream cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Write);
			byte[] bytes3 = Encoding.ASCII.GetBytes(prm_text_to_encrypt);
			cryptoStream.Write(bytes3, 0, bytes3.Length);
			cryptoStream.FlushFinalBlock();
			byte[] inArray = memoryStream.ToArray();
			return Convert.ToBase64String(inArray);
		}
	}
}
