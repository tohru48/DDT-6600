namespace Game.Server.Managers
{
    using log4net;
    using Microsoft.CSharp;
    using Microsoft.VisualBasic;
    using System;
    using System.CodeDom.Compiler;
    using System.Collections;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Text;

    public class ScriptMgr
    {
        private static readonly ILog log;
        private static readonly Dictionary<string, Assembly> m_scripts;

        static ScriptMgr()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            m_scripts = new Dictionary<string, Assembly>();
        }

        public ScriptMgr()
        {
        }

        public static bool CompileScripts(bool compileVB, string path, string dllName, string[] asm_names)
        {
            if (!path.EndsWith(@"\") && !path.EndsWith("/"))
            {
                path = path + "/";
            }
            ArrayList list = ParseDirectory(new DirectoryInfo(path), compileVB ? "*.vb" : "*.cs", true);
            if (list.Count != 0)
            {
                if (File.Exists(dllName))
                {
                    File.Delete(dllName);
                }
                CompilerResults results = null;
                try
                {
                    CodeDomProvider provider = null;
                    if (compileVB)
                    {
                        provider = new VBCodeProvider();
                    }
                    else
                    {
                        provider = new CSharpCodeProvider();
                    }
                    CompilerParameters options = new CompilerParameters(asm_names, dllName, true)
                    {
                        GenerateExecutable = false,
                        GenerateInMemory = false,
                        WarningLevel = 2,
                        CompilerOptions = "/lib:."
                    };
                    string[] fileNames = new string[list.Count];
                    for (int i = 0; i < list.Count; i++)
                    {
                        fileNames[i] = ((FileInfo)list[i]).FullName;
                    }
                    results = provider.CompileAssemblyFromFile(options, fileNames);
                    GC.Collect();
                    if (results.Errors.HasErrors)
                    {
                        foreach (CompilerError error in results.Errors)
                        {
                            if (!error.IsWarning)
                            {
                                StringBuilder builder = new StringBuilder();
                                builder.Append("   ");
                                builder.Append(error.FileName);
                                builder.Append(" Line:");
                                builder.Append(error.Line);
                                builder.Append(" Col:");
                                builder.Append(error.Column);
                                if (log.IsErrorEnabled)
                                {
                                    log.Error("Script compilation failed because: ");
                                    log.Error(error.ErrorText);
                                    log.Error(builder.ToString());
                                }
                            }
                        }
                        return false;
                    }
                }
                catch (Exception exception)
                {
                    if (log.IsErrorEnabled)
                    {
                        log.Error("CompileScripts", exception);
                    }
                }
                if ((results != null) && !results.Errors.HasErrors)
                {
                    InsertAssembly(results.CompiledAssembly);
                }
            }
            return true;
        }

        public static object CreateInstance(string name)
        {
            foreach (Assembly assembly in Scripts)
            {
                Type type = assembly.GetType(name);
                if ((type != null) && type.IsClass)
                {
                    return Activator.CreateInstance(type);
                }
            }
            return null;
        }

        public static object CreateInstance(string name, Type baseType)
        {
            foreach (Assembly assembly in Scripts)
            {
                Type c = assembly.GetType(name);
                if (((c != null) && c.IsClass) && baseType.IsAssignableFrom(c))
                {
                    return Activator.CreateInstance(c);
                }
            }
            return null;
        }

        public static Type[] GetDerivedClasses(Type baseType)
        {
            if (baseType == null)
            {
                return new Type[0];
            }
            ArrayList list = new ArrayList();
            ArrayList list2 = new ArrayList(Scripts);
            foreach (Assembly assembly in list2)
            {
                foreach (Type type in assembly.GetTypes())
                {
                    if (type.IsClass && baseType.IsAssignableFrom(type))
                    {
                        list.Add(type);
                    }
                }
            }
            return (Type[])list.ToArray(typeof(Type));
        }

        public static Type[] GetImplementedClasses(string baseInterface)
        {
            ArrayList list = new ArrayList();
            ArrayList list2 = new ArrayList(Scripts);
            foreach (Assembly assembly in list2)
            {
                foreach (Type type in assembly.GetTypes())
                {
                    if (type.IsClass && (type.GetInterface(baseInterface) != null))
                    {
                        list.Add(type);
                    }
                }
            }
            return (Type[])list.ToArray(typeof(Type));
        }

        public static Type GetType(string name)
        {
            foreach (Assembly assembly in Scripts)
            {
                Type type = assembly.GetType(name);
                if (type != null)
                {
                    return type;
                }
            }
            return null;
        }

        public static bool InsertAssembly(Assembly ass)
        {
            lock (m_scripts)
            {
                if (!m_scripts.ContainsKey(ass.FullName))
                {
                    m_scripts.Add(ass.FullName, ass);
                    return true;
                }
                return false;
            }
        }

        private static ArrayList ParseDirectory(DirectoryInfo path, string filter, bool deep)
        {
            ArrayList list = new ArrayList();
            if (path.Exists)
            {
                list.AddRange(path.GetFiles(filter));
                if (!deep)
                {
                    return list;
                }
                foreach (DirectoryInfo info in path.GetDirectories())
                {
                    list.AddRange(ParseDirectory(info, filter, deep));
                }
            }
            return list;
        }

        public static bool RemoveAssembly(Assembly ass)
        {
            lock (m_scripts)
            {
                return m_scripts.Remove(ass.FullName);
            }
        }

        public static Assembly[] Scripts
        {
            get
            {
                lock (m_scripts)
                {
                    return m_scripts.Values.ToArray<Assembly>();
                }
            }
        }
    }
}
