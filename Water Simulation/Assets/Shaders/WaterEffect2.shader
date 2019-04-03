Shader "Custom/WaterEffect2" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_Speed("Speed", Range(0, 10)) = 5
		_WaveStrength("WaveStrength", Range(0, 10)) = 1.0
		_Wavelength("Wavelength", Range(0, 10000)) = 3.14
		_WaveCenter1("WaveCenter1", Vector) = (0.5, 0.5, 0, 0)
		_WaveCenter2("WaveCenter2", Vector) = (0.5, 0.5, 0, 0)
	}
	SubShader {
		Tags 
		{
			"Queue" = "Transparent"
			"RenderType"="Opaque"
		}
		ZWrite off
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha
		#pragma vertex vert
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _Steepness;
		float _WaveStrength;
		float _Wavelength;
		float _Speed;
		float4 _WaveCenter1;
		float4 _WaveCenter2;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		float sinWave(float3 P, float2 Center){
			float A = _WaveStrength;
			float direction;
			direction = (Center.xy - P.xz) / length(P.xz - Center.xy);
			float w = sqrt(9.81 * (2 * 3.1416 / _Wavelength));
			return A * sin(dot(P.xz, direction) * w + _Time * _Speed * 10);
		}

		void vert(inout appdata_full v){
			float3 P = v.vertex.xyz;
			v.vertex.xyz += float3(0, sinWave(P, _WaveCenter1), 0);
			v.vertex.xyz += float3(0, sinWave(P, _WaveCenter2), 0);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
