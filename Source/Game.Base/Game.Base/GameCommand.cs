namespace Game.Base
{
    using System;

    public class GameCommand
    {
        public string m_cmd;
        public ICommandHandler m_cmdHandler;
        public string m_desc;
        public uint m_lvl;
        public string[] m_usage;

        public GameCommand()
        {
        }
    }
}
