using System.Collections;
using System.IO;
using System.Text;

namespace Tank.Request.Illegalcharacters
{
	public class FileSystem
	{
		public ArrayList contentList = new ArrayList();

		private FileSystemWatcher fileWatcher = new FileSystemWatcher();

		private string filePath = string.Empty;

		private string fileDirectory = string.Empty;

		private string fileType = string.Empty;

		public FileSystem(string Path, string Directory, string Type)
		{
			initContent(Path);
			initFileWatcher(Directory, Type);
		}

		private void initContent(string Path)
		{
			if (!File.Exists(Path))
			{
				return;
			}
			filePath = Path;
			StreamReader streamReader = new StreamReader(Path, Encoding.GetEncoding("GB2312"));
			string text = "";
			if (contentList.Count > 0)
			{
				contentList.Clear();
			}
			while (text != null)
			{
				text = streamReader.ReadLine();
				if (!string.IsNullOrEmpty(text))
				{
					contentList.Add(text);
				}
			}
			if (text == null)
			{
				streamReader.Close();
			}
		}

		private void initFileWatcher(string directory, string type)
		{
			if (Directory.Exists(directory))
			{
				fileDirectory = directory;
				fileType = type;
				fileWatcher.Path = directory;
				fileWatcher.Filter = type;
				fileWatcher.NotifyFilter = NotifyFilters.FileName | NotifyFilters.LastWrite | NotifyFilters.LastAccess;
				fileWatcher.EnableRaisingEvents = true;
				fileWatcher.Changed += OnChanged;
				fileWatcher.Renamed += OnRenamed;
			}
		}

		public bool checkIllegalChar(string strRegName)
		{
			bool result = false;
			if (!string.IsNullOrEmpty(strRegName))
			{
				result = checkChar(strRegName);
			}
			return result;
		}

		private bool checkChar(string strRegName)
		{
			bool flag = false;
			foreach (string text in contentList)
			{
				if (!text.StartsWith("GM"))
				{
					string text2 = text;
					for (int i = 0; i < text2.Length; i++)
					{
						if (strRegName.Contains(text2[i].ToString()))
						{
							flag = true;
							break;
						}
					}
					if (flag)
					{
						break;
					}
					continue;
				}
				string[] array = text.Split('|');
				string[] array2 = array;
				for (int j = 0; j < array2.Length; j++)
				{
					string value = array2[j];
					if (strRegName.Contains(value))
					{
						flag = true;
						break;
					}
				}
				if (!flag)
				{
					continue;
				}
				break;
			}
			return flag;
		}

		private void OnChanged(object source, FileSystemEventArgs e)
		{
			UpdataContent();
		}

		private void UpdataContent()
		{
			initContent(filePath);
		}

		private static void OnRenamed(object source, RenamedEventArgs e)
		{
		}
	}
}
