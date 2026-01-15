namespace Game.Base
{
    using Game.Base.Events;
    using Game.Server.Managers;
    using log4net;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Reflection;
    using System.Text;

    public class CommandMgr
    {
        private static readonly ILog log;
        private static Hashtable m_cmds;
        private static string[] m_disabledarray;

        static CommandMgr()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            m_cmds = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
            m_disabledarray = new string[0];
        }

        public CommandMgr()
        {
        }

        public static void DisplaySyntax(BaseClient client)
        {
            client.DisplayMessage("Commands list:");
            foreach (string str in GetCommandList(ePrivLevel.Admin, true))
            {
                client.DisplayMessage("         " + str);
            }
        }

        private static bool ExecuteCommand(BaseClient client, GameCommand myCommand, string[] pars)
        {
            pars[0] = myCommand.m_cmd;
            return myCommand.m_cmdHandler.OnCommand(client, pars);
        }

        public static GameCommand GetCommand(string cmd)
        {
            return (m_cmds[cmd] as GameCommand);
        }

        public static string[] GetCommandList(ePrivLevel plvl, bool addDesc)
        {
            IDictionaryEnumerator enumerator = m_cmds.GetEnumerator();
            ArrayList list = new ArrayList();
            while (enumerator.MoveNext())
            {
                GameCommand command = enumerator.Value as GameCommand;
                string key = enumerator.Key as string;
                if ((command != null) && (key != null))
                {
                    if (key[0] == '&')
                    {
                        key = '/' + key.Remove(0, 1);
                    }
                    if (plvl >= (ePrivLevel)command.m_lvl)
                    {
                        if (addDesc)
                        {
                            list.Add(key + " - " + command.m_desc);
                        }
                        else
                        {
                            list.Add(command.m_cmd);
                        }
                    }
                }
            }
            return (string[])list.ToArray(typeof(string));
        }

        public static GameCommand GuessCommand(string cmd)
        {
            GameCommand command = GetCommand(cmd);
            if (command == null)
            {
                string str = cmd.ToLower();
                IDictionaryEnumerator enumerator = m_cmds.GetEnumerator();
                while (enumerator.MoveNext())
                {
                    GameCommand command2 = enumerator.Value as GameCommand;
                    string key = enumerator.Key as string;
                    if ((command2 != null) && key.ToLower().StartsWith(str))
                    {
                        return command2;
                    }
                }
            }
            return command;
        }

        public static bool HandleCommandNoPlvl(BaseClient client, string cmdLine)
        {
            try
            {
                string[] pars = ParseCmdLine(cmdLine);
                GameCommand myCommand = GuessCommand(pars[0]);
                if (myCommand == null)
                {
                    return false;
                }
                ExecuteCommand(client, myCommand, pars);
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("HandleCommandNoPlvl", exception);
                }
            }
            return true;
        }

        public static bool LoadCommands()
        {
            m_cmds.Clear();
            ArrayList list = new ArrayList(ScriptMgr.Scripts);
            foreach (Assembly assembly in list)
            {
                foreach (Type type in assembly.GetTypes())
                {
                    if (type.IsClass && (type.GetInterface("Game.Base.ICommandHandler") != null))
                    {
                        try
                        {
                            foreach (CmdAttribute attribute in type.GetCustomAttributes(typeof(CmdAttribute), false))
                            {
                                bool flag = false;
                                foreach (string str in m_disabledarray)
                                {
                                    if (attribute.Cmd.Replace('&', '/') == str)
                                    {
                                        goto Label_00D4;
                                    }
                                }
                                goto Label_00D7;
                            Label_00D4:
                                flag = true;
                            Label_00D7:
                                if (!flag && !m_cmds.ContainsKey(attribute.Cmd))
                                {
                                    GameCommand command = new GameCommand
                                    {
                                        m_usage = attribute.Usage,
                                        m_cmd = attribute.Cmd,
                                        m_lvl = attribute.Level,
                                        m_desc = attribute.Description,
                                        m_cmdHandler = (ICommandHandler)Activator.CreateInstance(type)
                                    };
                                    m_cmds.Add(attribute.Cmd, command);
                                    if (attribute.Aliases != null)
                                    {
                                        foreach (string str2 in attribute.Aliases)
                                        {
                                            m_cmds.Add(str2, command);
                                        }
                                    }
                                }
                            }
                        }
                        catch (Exception exception)
                        {
                            if (log.IsErrorEnabled)
                            {
                                log.Error("LoadCommands", exception);
                            }
                        }
                    }
                }
            }
            return true;
        }

        [ScriptLoadedEvent]
        public static void OnScriptCompiled(RoadEvent ev, object sender, EventArgs args)
        {
            LoadCommands();
        }

        private static string[] ParseCmdLine(string cmdLine)
        {
            if (cmdLine == null)
            {
                throw new ArgumentNullException("cmdLine");
            }
            List<string> list = new List<string>();
            int num = 0;
            StringBuilder builder = new StringBuilder(cmdLine.Length >> 1);
            for (int i = 0; i < cmdLine.Length; i++)
            {
                char ch = cmdLine[i];
                switch (num)
                {
                    case 0:
                        {
                            if (ch != ' ')
                            {
                                builder.Length = 0;
                                if (ch != '"')
                                {
                                    break;
                                }
                                num = 2;
                            }
                            continue;
                        }
                    case 1:
                        {
                            if (ch == ' ')
                            {
                                list.Add(builder.ToString());
                                num = 0;
                            }
                            builder.Append(ch);
                            continue;
                        }
                    case 2:
                        {
                            if (ch == '"')
                            {
                                list.Add(builder.ToString());
                                num = 0;
                            }
                            builder.Append(ch);
                            continue;
                        }
                    default:
                        {
                            continue;
                        }
                }
                num = 1;
                i--;
            }
            if (num != 0)
            {
                list.Add(builder.ToString());
            }
            string[] array = new string[list.Count];
            list.CopyTo(array);
            return array;
        }

        public static string[] DisableCommands
        {
            get
            {
                return m_disabledarray;
            }
            set
            {
                m_disabledarray = (value == null) ? new string[0] : value;
            }
        }
    }
}
