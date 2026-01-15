namespace Game.Base
{
    using System;
    using System.IO;
    using System.Reflection;

    public class ResourceUtil
    {
        public ResourceUtil()
        {
        }

        public static void ExtractResource(string fileName, Assembly assembly)
        {
            ExtractResource(fileName, fileName, assembly);
        }

        public static void ExtractResource(string resourceName, string fileName, Assembly assembly)
        {
            FileInfo info = new FileInfo(fileName);
            if (!info.Directory.Exists)
            {
                info.Directory.Create();
            }
            using (StreamReader reader = new StreamReader(GetResourceStream(resourceName, assembly)))
            {
                using (StreamWriter writer = new StreamWriter(File.Create(fileName)))
                {
                    writer.Write(reader.ReadToEnd());
                }
            }
        }

        public static Stream GetResourceStream(string fileName, Assembly assem)
        {
            fileName = fileName.ToLower();
            foreach (string str in assem.GetManifestResourceNames())
            {
                if (str.ToLower().EndsWith(fileName))
                {
                    return assem.GetManifestResourceStream(str);
                }
            }
            return null;
        }
    }
}
