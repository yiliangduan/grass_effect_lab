// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "YiLiang/Effect/GrassEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _SwingTex ("Swing Tex", 2D) = "white" {}

        _NoiseTex ("Noise Tex", 2D) = "white" {}

        _Strength ("Stength", Float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "RenderQueue"="Transparent"}
        LOD 100

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

                float4 debug : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _SwingTex;
            float4 _SwingTex_ST;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;

            float _Strength;

            v2f vert (appdata v)
            {
                v2f o;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);

                fixed4 baseStength = tex2Dlod(_SwingTex, fixed4(TRANSFORM_TEX(v.uv, _SwingTex), 0, 0));
                fixed4 swingOffset = tex2Dlod(_NoiseTex, fixed4(TRANSFORM_TEX(v.uv + float2(_Time.y, _Time.y*0.5), _NoiseTex), 0, 0));

                worldPos.z +=  _Strength * swingOffset.x * baseStength.r;

                o.vertex = mul(UNITY_MATRIX_VP, worldPos);

                o.debug = baseStength;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                return col;
            }
            ENDCG
        }
    }
}
