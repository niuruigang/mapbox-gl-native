#pragma once

#include <mbgl/sprite/sprite_atlas.hpp>
#include <mbgl/tile/tile.hpp>
#include <mbgl/tile/geometry_tile_worker.hpp>
#include <mbgl/text/glyph_atlas.hpp>
#include <mbgl/text/placement_config.hpp>
#include <mbgl/util/feature.hpp>
#include <mbgl/actor/actor.hpp>

#include <atomic>
#include <memory>
#include <unordered_map>
#include <vector>

namespace mbgl {

class GeometryTileData;
class FeatureIndex;
class CollisionTile;

namespace style {
class Style;
class Layer;
class UpdateParameters;
class SourceQueryOptions;
} // namespace style

class GeometryTile : public Tile, public GlyphRequestor, IconRequestor {
public:
    GeometryTile(const OverscaledTileID&,
                 std::string sourceID,
                 const style::UpdateParameters&);

    ~GeometryTile() override;

    void setError(std::exception_ptr);
    void setData(std::unique_ptr<const GeometryTileData>);

    void setPlacementConfig(const PlacementConfig&) override;
    void redoLayout() override;
    
    void onGlyphsAvailable(GlyphPositionMap, GlyphRangeSet) override;
    void onIconsAvailable(SpriteAtlas*, IconMap) override;
    
    void getGlyphs(GlyphDependencies);
    void getIcons(IconDependencyMap);

    Bucket* getBucket(const style::Layer&) override;

    void queryRenderedFeatures(
            std::unordered_map<std::string, std::vector<Feature>>& result,
            const GeometryCoordinates& queryGeometry,
            const TransformState&,
            const RenderedQueryOptions& options) override;

    void querySourceFeatures(
        std::vector<Feature>& result,
        const style::SourceQueryOptions&) override;

    void cancel() override;

    class LayoutResult {
    public:
        std::unordered_map<std::string, std::shared_ptr<Bucket>> nonSymbolBuckets;
        std::unique_ptr<FeatureIndex> featureIndex;
        std::unique_ptr<GeometryTileData> tileData;
        uint64_t correlationID;
    };
    void onLayout(LayoutResult);

    class PlacementResult {
    public:
        std::unordered_map<std::string, std::shared_ptr<Bucket>> symbolBuckets;
        std::unique_ptr<CollisionTile> collisionTile;
        uint64_t correlationID;
    };
    void onPlacement(PlacementResult);

    void onError(std::exception_ptr);
    
protected:
    const GeometryTileData* getData() {
        return data.get();
    }

private:
    const std::string sourceID;
    style::Style& style;

    // Used to signal the worker that it should abandon parsing this tile as soon as possible.
    std::atomic<bool> obsolete { false };

    std::shared_ptr<Mailbox> mailbox;
    Actor<GeometryTileWorker> worker;

    GlyphAtlas& glyphAtlas;
    std::set<SpriteAtlas*> pendingSpriteAtlases;
    IconAtlasMap iconAtlasMap;
    
    uint64_t correlationID = 0;
    optional<PlacementConfig> requestedConfig;

    std::unordered_map<std::string, std::shared_ptr<Bucket>> nonSymbolBuckets;
    std::unique_ptr<FeatureIndex> featureIndex;
    std::unique_ptr<const GeometryTileData> data;

    std::unordered_map<std::string, std::shared_ptr<Bucket>> symbolBuckets;
    std::unique_ptr<CollisionTile> collisionTile;
};

} // namespace mbgl
