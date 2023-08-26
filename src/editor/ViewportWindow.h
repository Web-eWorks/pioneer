// Copyright © 2008-2023 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#pragma once

#include "editor/EditorWindow.h"
#include "graphics/Graphics.h"
#include "imgui/imgui.h"

#include <memory>

namespace Graphics
{
	class Renderer;
	class RenderTarget;
}

namespace Editor
{

	class ViewportWindow : public EditorWindow {
	public:
		ViewportWindow(EditorApp *app);
		~ViewportWindow();

		virtual void OnAppearing() override;
		virtual void OnDisappearing() override;

		virtual void Update(float deltaTime) override;

	protected:

		virtual void OnUpdate(float deltaTime) = 0;
		virtual void OnRender(Graphics::Renderer *renderer) = 0;

		virtual void OnHandleInput(bool clicked, bool released, ImVec2 mousePos) = 0;

		void CreateRenderTarget();

		Graphics::RenderTarget *GetRenderTarget() { return m_renderTarget.get(); }
		const Graphics::ViewportExtents &GetViewportExtents() const { return m_viewportExtents; }


	private:

		std::unique_ptr<Graphics::RenderTarget> m_renderTarget;
		Graphics::ViewportExtents m_viewportExtents;

		bool m_viewportActive;
		bool m_viewportHovered;

	};
}
