using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrassInteraction : MonoBehaviour
{
    public MeshRenderer Role;

    private MeshRenderer[] mGrassArray;

    private int GrassShaderRolePosID;

    public void Awake()
    {
        mGrassArray = GetComponentsInChildren<MeshRenderer>();

        GrassShaderRolePosID = Shader.PropertyToID("_RolePos");
    }


    public void Update()
    {
        if (null == Role || null == mGrassArray)
        {
            return;
        }

        for (int i=0; i<mGrassArray.Length; ++i)
        {
            mGrassArray[i].sharedMaterial.SetVector(GrassShaderRolePosID, Role.transform.position);
        }
    }
}
