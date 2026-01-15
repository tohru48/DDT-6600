using Game.Logic;
using Game.Server.Rooms;

internal class Class23 : IAction
{
	private BaseRoom baseRoom_0;

	private eRoomType eRoomType_0;

	private byte byte_0;

	private eHardLevel eHardLevel_0;

	private int int_0;

	private int int_1;

	private string string_0;

	private string string_1;

	private bool bool_0;

	private bool bool_1;

	private string string_2;

	private int int_2;

	public Class23(BaseRoom baseRoom_1, eRoomType eRoomType_1, byte byte_1, eHardLevel eHardLevel_1, int int_3, int int_4, string string_3, string string_4, bool bool_2, bool bool_3, string string_5, int int_5)
	{
		baseRoom_0 = baseRoom_1;
		eRoomType_0 = eRoomType_1;
		byte_0 = byte_1;
		eHardLevel_0 = eHardLevel_1;
		int_1 = int_3;
		int_0 = int_4;
		string_0 = string_3;
		string_1 = string_4;
		bool_0 = bool_2;
		bool_1 = bool_3;
		string_2 = string_5;
		int_2 = int_5;
		if (!bool_3)
		{
			return;
		}
		switch (int_4)
		{
		case 1:
			if (eHardLevel_0 == eHardLevel.Easy)
			{
				int_2 = 2;
				string_2 = "show2.jpg";
			}
			else if (eHardLevel_0 == eHardLevel.Normal)
			{
				int_2 = 3;
				string_2 = "show3.jpg";
			}
			else if (eHardLevel_0 == eHardLevel.Hard)
			{
				int_2 = 4;
				string_2 = "show4.jpg";
			}
			else
			{
				int_2 = 5;
				string_2 = "show5.jpg";
			}
			break;
		case 2:
			int_2 = 2;
			string_2 = "show2.jpg";
			break;
		default:
			int_2 = 4;
			string_2 = "show4.jpg";
			break;
		case 4:
		case 14:
			int_2 = 3;
			string_2 = "show3.jpg";
			break;
		}
	}

	public void Execute()
	{
		baseRoom_0.RoomType = eRoomType_0;
		baseRoom_0.TimeMode = byte_0;
		baseRoom_0.HardLevel = eHardLevel_0;
		baseRoom_0.LevelLimits = int_1;
		baseRoom_0.MapId = int_0;
		baseRoom_0.Name = string_1;
		baseRoom_0.Password = string_0;
		baseRoom_0.isCrosszone = bool_0;
		baseRoom_0.isOpenBoss = bool_1;
		baseRoom_0.currentFloor = int_2;
		baseRoom_0.Pic = string_2;
		baseRoom_0.UpdateRoomGameType();
		baseRoom_0.SendRoomSetupChange(baseRoom_0);
		RoomMgr.WaitingRoom.SendUpdateCurrentRoom(baseRoom_0);
	}
}
