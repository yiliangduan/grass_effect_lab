
Shader "YiLiang/Effect/GrassEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _SwingTex ("Swing Tex", 2D) = "white" {}

        _Strength ("Stength", Float) = 0.5

        _Speed ("Speed", Float) = 0.5

        _RoleReactDistance ("Role React Distance", Float) = 0.5

        _YOffset("Y offset", float) = 0.0// y offset, below this is no animation

        _MaxWidth("Max Displacement Width", Range(0, 2)) = 0.1 // width of the line around the dissolve

        _Radius("Radius", Range(0,5)) = 1 // width of the line around the dissolve

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "RenderQueue"="Transparent"}
        LOD 100

        //草需要双面渲染，关闭裁剪
        Cull Off

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
       
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _SwingTex;
            float4 _SwingTex_ST;

            float _Strength;
            float _Speed;

            float3 _RolePos;
            float _RoleReactDistance;

            float _YOffset;
            float _Rigidness;
            float _MaxWidth;

            //平滑 曲线
            float4 SmoothCurve( float4 x )
            {
                return x * x * (3.0 - 2.0 * x);
            }

            //波
            float4 TriangleWave( float4 x )
            {
                return abs (frac( x + 0.5 ) * 2.0 - 1.0);
            }

            //波平滑
            float4 SmoothTriangleWave( float4 x )
            {
                return SmoothCurve(TriangleWave( x ));
            }

            //草的风吹摇摆效果的相位变化
			float3 GrassSwingPhase(float4 vertex, fixed phaseWeight)
			{
				float4 worldPos = mul(unity_ObjectToWorld, vertex);

				fixed branchPhase = dot(worldPos, 1);

				float vtxPhase = dot(vertex.xyz, branchPhase);
				float wavesIn = _Time.y + vtxPhase;

				float4 waves = (frac(wavesIn.xxxx * float4(1.975, 0.793, 0.375, 0.193)) * 2.0 - 1.0) * _Speed * phaseWeight;

				waves = SmoothTriangleWave(waves);

				float2 wavesSum = waves.xz + waves.yw;

				return wavesSum.xxy * _Speed;
			}

            v2f vert (appdata input)
            {
                v2f o;

                o.uv = TRANSFORM_TEX(input.uv, _MainTex);

                //相位变化权重，草的根部近似0，越往草尖，值越大
                fixed phaseWeight = max(0, tex2Dlod(_SwingTex, fixed4(TRANSFORM_TEX(input.uv, _SwingTex), 0, 0)).r);

                float4 vertexPhase = float4(input.vertex.xyz + GrassSwingPhase(input.vertex, phaseWeight), input.vertex.w);
                /*
                float4 worldPos = mul(unity_ObjectToWorld, input.vertex);
                float distanceToRole = distance(_RolePos, worldPos.xyz);
                
                //float reactDistance = max(0, (_RoleReactDistance - distanceToRole)); 

                float radius = 1 - saturate(distanceToRole / _RoleReactDistance);

                float3 sphereDisp = worldPos -_RolePos;

                sphereDisp *= radius;

                vertexPhase.xz += clamp(distanceToRole * step(_YOffset, input.vertex.y), -_MaxWidth, _MaxWidth);
                */
                o.vertex = UnityObjectToClipPos(vertexPhase);

                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
                return col;
            }
            ENDCG
        }
    }
}
