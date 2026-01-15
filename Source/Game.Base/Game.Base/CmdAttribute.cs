namespace Game.Base
{
    using System;

    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true)]
    public class CmdAttribute : Attribute
    {
        private string m_cmd;
        private string[] m_cmdAliases;
        private string m_description;
        private uint m_lvl;
        private string[] m_usage;

        public CmdAttribute(string cmd, ePrivLevel lvl, string desc, params string[] usage)
            : this(cmd, null, lvl, desc, usage)
        {
        }

        public CmdAttribute(string cmd, string[] alias, ePrivLevel lvl, string desc, params string[] usage)
        {
            this.m_cmd = cmd;
            this.m_cmdAliases = alias;
            this.m_lvl = (uint)lvl;
            this.m_description = desc;
            this.m_usage = usage;
        }

        public string[] Aliases
        {
            get
            {
                return this.m_cmdAliases;
            }
        }

        public string Cmd
        {
            get
            {
                return this.m_cmd;
            }
        }

        public string Description
        {
            get
            {
                return this.m_description;
            }
        }

        public uint Level
        {
            get
            {
                return this.m_lvl;
            }
        }

        public string[] Usage
        {
            get
            {
                return this.m_usage;
            }
        }
    }
}
