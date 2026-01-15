using Game.Base.Events;
using Game.Logic;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Logic.Cmd
{
    public class CommandMgr
    {
        private static Dictionary<int, ICommandHandler> handles;

        static CommandMgr()
        {
            CommandMgr.handles = new Dictionary<int, ICommandHandler>();
        }

        public CommandMgr()
        {

        }

        public static ICommandHandler LoadCommandHandler(int code)
        {
            return CommandMgr.handles[code];
        }

        [ScriptLoadedEvent]
        public static void OnScriptCompiled(RoadEvent ev, object sender, EventArgs args)
        {
            CommandMgr.handles.Clear();
            CommandMgr.SearchCommandHandlers(Assembly.GetAssembly(typeof(BaseGame)));
        }

        protected static int SearchCommandHandlers(Assembly assembly)
        {
            int num = 0;
            foreach (Type type in assembly.GetTypes())
            {
                if (type.IsClass && type.GetInterface("Game.Logic.Cmd.ICommandHandler") != null)
                {
                    GameCommandAttribute[] commandAttributeArray = (GameCommandAttribute[])type.GetCustomAttributes(typeof(GameCommandAttribute), true);
                    if (commandAttributeArray.Length > 0)
                    {
                        ++num;
                        CommandMgr.RegisterCommandHandler(commandAttributeArray[0].Code, Activator.CreateInstance(type) as ICommandHandler);
                    }
                }
            }
            return num;
        }

        protected static void RegisterCommandHandler(int code, ICommandHandler handle)
        {
            CommandMgr.handles.Add(code, handle);
        }
    }
}
